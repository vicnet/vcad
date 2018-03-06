/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2015  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: multpath.scad
 * Matrices for 3d transformations along a path.
 * Use with multmatrix buildin module.
 * Modules with same name should be find in <transform.scad>
 * that apply multmatrix to these matrices onto objects.
 * See <transform.scad> or <duplicate.scad>
 * Example:
 * > use <vcad/multpath.scad>
 */

include <vcad/path.scad>


/**
 * Function: vfollow
 * Returns a transformation matrix to:
 * - twist by <t>,
 * - scale by <s>,
 * - rotate to <v>,
 * - move to <o>.
 * Parameters:
 *   v - normal or vector of normals
 *   o - position or vector of positions
 *   s - scale (scalar or vector or list of vectors)
 *   t - twist (scalar or vectors)
 * Returns:
 *   A transformation matrix or list of transformation matrix.
 * Example:
 * > 
 */
function vfollow(v, o=V0, s=1, t=0) =
    vlevel(v)==1
/*
    ? let( r = norm(v), t2 = r>0 ? acos(v[2]/r) : 0
         , p2 = v[0]!=0 ? atan(v[1]/v[0]) : 0, p3 = v[0]>=0?p2:180+p2 )
      vtr(o) * vrz(p3)*vry(t2) * vscale(s) * vrz(t)
*/
    ? let( l = norm(v), c = l>0 ? acos(v[2]/l) : 0
        , l2 = norm([v[0],v[1],0]), b = l2>0 ? acos(v[0]/l2) : 0 )
        vtr(o) * vrz(90+b*(v[1]>0?1:-1)) * vrx(c) * vscale(s) * vrz(t)
    : let( n=len(v), vs = visnum(s) ? [1,s] : s, ts = visnum(t) ? [0,t] : t )
      [ for(i=vindexes(v)) vfollow(v[i], o[i], vlookup(i,vs,n), vlookup(i,ts,n)) ];

/**
 * Function: vfollow_simple
 * Returns a list of transformation matrix to follow <path>
 * without change base object normal (translate only).
 * Useful for object without orientation (spherical object).
 * Parameters:
 *   pts - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > 
 */
function vfollow_simple(path, s=1, t=0) =
    let( ps = $fn<=0 ? path : vcut(path)
       , vs = vvect(len(ps),VZ) )
    vfollow(vs,ps,s,t);

/**
 * Function: vfollow_direct
 * Returns a list of transformation matrix to follow <path>
 * change normal along <path> (last orientation is in last
 * vector direction).
 * Parameters:
 *   pts - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > 
 */
function vfollow_direct(path, s=1, t=0) =
    let( ps = $fn<=0 ? path : vcut(path)
       , tvs = vsub2(ps)
       , last=velem(tvs,end=-1)
       , vs = concat(tvs,[last]) )
    vfollow(vs,ps,s,t);

/**
 * Function: vfollow_middle
 * Returns a list of transformation matrix to follow <path>
 * change normal along middle of vector in <path>
 * (first and last orientation direct vector direction).
 * Parameters:
 *   pts - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > 
 */
function vfollow_middle(path, s=1, t=0) =
    let( ps = path
       , tvs = vsub2(path)
       , first = tvs[0]
       , last= velem(tvs,end=-1)
       , vs = concat([first],vsum2(tvs),[last]) )
    vfollow(vs,ps,s,t);

/**
 * Function: vfollow_dup
 * Returns a list of transformation matrix to follow <path>
 * with begin and end of each vector.
 * Parameters:
 *   pts - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > 
 */
function vfollow_dup(path, s=1, t=0) =
    let( ps = vcopy(path, start=1, end=-1, inc=-2)
       , vs = vcopy(vsub2(path),inc=-2) )
    vfollow(vs,ps,s,t);

/**
 * Function: vfollow_bezier3
 * Returns a list of transformation matrix to follow <path>
 * on bezier curve with 1 control point between position points.
 * Parameters:
 *   pts - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > 
 */
function vfollow_bezier3(path, s=1, t=0) =
    vfollow_direct(vbezier3(path),s,t,$fn=0);

/**
 * Function: vfollow_bezier4
 * Returns a list of transformation matrix to follow <path>
 * on bezier curve with 2 control points between position points.
 * Parameters:
 *   pts - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > 
 */
function vfollow_bezier4(path, s=1, t=0, c=0.5) =
    let (ps = c==0 ? path : vcontrol(path,c))
    vfollow_direct(vbezier4(ps),s,t,$fn=0);

/**
 * Function: vfollow_rot
 * Returns a list of transformation matrix to extrude
 * in rotation along Z from 0 to <a> degree.
 * Plane X,Y is reference, and Z is normal.
 * After scale <s>, a first <r> or <d> translation matrix
 * is applied then a rotation matrix around X is applied and
 * then final rotation around Z.
 * $fn could be used as number of matrices.
 * Parameters:
 *   a - final angle
 *   r - translation radius (used first, then <d>)
 *   d - translation diameter (used if <r> not defined)
 *   s - scale, scalar or list of scalar or list of vectors
 *   normal - first object rotation
 *   h - total height of helix (default: 0 ie flat, no helix)
 * Returns:
 *   A list of transformation matrix for a rotation
 *   along Z from 0 to <a> degree.
 * Example:
 * > 
 */
function vfollow_rot(a=360, r, s=1, d, normal=VY, h=0) =
    let( n = $fn<=0 ? min(4,round(13*a/360)) : $fn
       , vs = visnum(s) ? [1,s] : s
       , r = vopt(r,d/2,0) )
    [ for (i = [0:n]) 
        vtz(h/n*i)*vrz(a/n*i)*vtx(r)*vrotate(normal)*vscale(vlookup(i,vs,n)) ];
