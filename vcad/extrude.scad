/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: extrude.scad
 * Module that extrude children along a path.
 * Example:
 * > use <vcad/extrude.scad>
 */

include <multmatrix.scad>
include <path.scad>
include <multpath.scad>


/**
 * Module: vhull2
 * Hull transformed children 2 by 2.
 * Parameters:
 *   ms - list of matrices.
 *   chamfer - hull intermediate chamfer.
 * Example:
 * > 
 * Remark: hull2 use a convex hull on children.
 * If children are concave, appply hull2 on each part
 * before assembling.
 */
module vhull2(ms, chamfer=true) {
    skip = chamfer ? 1 : 2;
    for ( i = [ 0 : skip : len(ms)-2 ] )
        hull() {
            multmatrix(ms[i]) children();
            multmatrix(ms[i+1]) children();
        }
}

/**
 * Module: vextrude_simple
 * Extrude children to follow <path> without change base
 * object normal (translate only).
 * Useful for object without orientation (spherical object).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vextrude_simple(path, s=1, t=0) {
    vhull2(vfollow_simple(path,s,t),true) children();
}

/**
 * Module: vextrude_direct
 * Extrude children to follow <path> and change normal
 * along <path> (last orientation is in last vector
 * direction).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vextrude_direct(path, s=1, t=0) {
    vhull2(vfollow_direct(path,s,t),true) children();
}

/**
 * Module: vextrude_middle
 * Extrude children to follow <path> change normal
 * along middle of vector in <path> (first and last
 * orientation direct vector direction).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vextrude_middle(path, s=1, t=0) {
    vhull2(vfollow_middle(path,s,t),true) children();
}

/**
 * Module: vextrude_dup
 * Extrude children to follow <path> with begin and end
 * of each vector.
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 *   chamfer - draw chamfer or not
 * Example:
 * > 
 */
module vextrude_dup(path, s=1, t=0, chamfer=true) {
    vhull2(vfollow_dup(path,s,t),chamfer) children();
}

/**
 * Module: vextrude_bezier3
 * Extrude children to follow <path> on bezier curve
 * with 1 control point between position points.
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vextrude_bezier3(path, s=1, t=0) {
    vextrude_direct(vbezier3(path),s,t) children();
}

/**
 * Module: vextrude_bezier4
 * Extrude children to follow <path> on bezier curve
 * with 2 control points between position points.
 * If weight control <c> is not null, control points
 * are generated with this contraint (default).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 *   c - weight control
 * Example:
 * > 
 */
module vextrude_bezier4(path, s=1, t=0, c=0.5) {
    ps = c==0 ? path : vcontrol(path,c);
    vextrude_direct(vbezier4(ps),s,t) children();
}

/**
 * Module: vextrude_rot
 * Extrude children in rotation along Z from
 * 0 to <a> degree.
 * Plane X,Y is reference, and Z is normal.
 * After scale <s>, a first <r> or <d> translation matrix
 * is applied then a rotation matrix around X is applied and
 * then final rotation around Z.
 * $fn could be used.
 * Parameters:
 *   a - final angle
 *   r - translation radius (used first, then <d>)
 *   s - scale, scalar or list of scalar or list of vectors
 * Example:
 * > 
 */
module vextrude_rot(a=360, r, s=1, d) {
    vhull2(vfollow_rot(a,r,s,d),true) children();
}
