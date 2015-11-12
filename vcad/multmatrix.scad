/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2015  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: multmatrix.scad
 * Contains matrices for 3d transformation.
 * Use with multmatrix multmatrix buildin module.
 * Modules with same name should be find in <transform.scad>
 * that apply multmatrix to these matrices.
 * Example:
 * > use <vcad/matrix.scad>
 */

include <vcad/constants.scad>
include <vcad/utilities.scad>
include <vcad/math.scad> // for vsq


/**
 * Function: vtr
 * Returns a transformation matrix (or list of matrices)
 * for a translation of <x>,<y>,<z>.
 * Parameters:
 *   x - x translation, a scalar, vector or list of vector.
 *   y - y translation.
 *   z - z translation.
 * Returns:
 *   A transformation matrix if parameters are scalar
 *   or <x> a vector.
 *   A list of transformation matrices if <x> is a list.
 * Example:
 * > echo(vtr([1,2,3])); // outputs [[1, 0, 0, 1], [0, 1, 0, 2], [0, 0, 1, 3], [0, 0, 0, 1]]
 */
function vtr(x=0, y=0, z=0) =
      vlevel(x)==0 ?
        [ [ 1, 0, 0, x ]
        , [ 0, 1, 0, y ]
        , [ 0, 0, 1, z ]
        , [ 0, 0, 0, 1 ] ]
    : vlevel(x)==1 ?
        vtr(x[0],x[1],x[2])
    : [ for (i=vindex(x)) vtr(x[i]) ];

/**
 * Function: vskew
 * Returns a transformation matrix skew-symetric cross product of a vector <v>.
 * Remark: not really a transformation matrix but use in other transformation. 
 * Parameters:
 *  v - vector
 * Returns:
 *   A transformation matrix.
 * Example:
 * > echo(vskew([1,2,3])); // outputs [[0, -3, 2], [3, 0, -1], [-2, 1, 0]]
 */
function vskew(v) = [
        [    0 , -v[2],  v[1], 0 ]
      , [  v[2],    0 , -v[0], 0 ]
      , [ -v[1],  v[0],    0,  0 ]
      , [    0 ,    0 ,    0,  0 ]
    ];

/**
 * Function: vrotation_norm
 * Returns a transformation matrix to rotate <from> onto <to>.
 * <from> and <to> should be normalized.
 * Parameters:
 *  a - base normalized vector
 *  b - aim normalized vector
 * Returns:
 *   A transformation matrix.
 * Example:
 * > echo(vrotation_norm([0,0,1],[1,0,0])); // outputs [[0, 0, 1], [0, 1, 0], [-1, 0, 0]]
 */
function vrotate_norm(to, from=VZ) =
    let(c = cross(from, to), sc=vskew(c), nc=norm(c))
        nc<VEPSILON
            ? vmunit(4)
            : vmunit(4)+sc+vsq(sc)*(1-vdot(to,from))/vsq(c); 

/**
 * Function: vrotation
 * Returns a transformation matrix to rotate <from> onto <to>.
 * <from> and <to> could be any vector.
 * Parameters:
 *  to - aim vector
 *  from - base vector (default Z)
 * Returns:
 *   A transformation matrix.
 * Example:
 * > echo(vrotation([0,0,2],[2,0,0])); // outputs [[0, 0, 1], [0, 1, 0], [-1, 0, 0]]
 */
function vrotate(to, from=VZ) =
    vrotate_norm(vnormalize(to), vnormalize(from));

/**
 * Function: vfollow
 * Returns a transformation matrix to move to <p>
 * and rotate normal <n> to <v>.
 * Parameters:
 *   v - normal or vector of normals
 *   p - position
 *   n - reference normal vector
 * Returns:
 *   A transformation matrix.
 * Example:
 * > 
 */
function vfollow(v, o=V0, n=VZ) =
    vlevel(v)==1 ?
          vtr(o) * vrotate(v, n)
        : [ for(i=vindex(v)) vfollow(v[i], o[i]) ];

/**
 * Enums: Chamfer types
 * VCHAMFER_NO      - no chamfer, just translations.
 * VCHAMFER_MID     - calculate middle of intersection.
 * VCHAMFER_2_EMPTY - duplicates points without link them.
 * VCHAMFER_2_FILL  - duplicates points and link them.
 */
VCHAMFER_NO=0;
VCHAMFER_MID=1;
VCHAMFER_2_EMPTY=2;
VCHAMFER_2_FILL=3;

/**
 * Function: vextrude
 * Returns a list of transformation matrix to extrude along <pts>.
 * Parameters:
 *   pts - path to follow
 *   chamfer - chamfer type
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > 
 */
function vextrude(pts, chamfer=VCHAMFER_2_FILL) =
      chamfer==VCHAMFER_NO ?
        vtr(pts)
    : chamfer==VCHAMFER_MID ?
        let( vs=vsub2(pts)
           , ns=concat([vs[0]],vsum2(vs),[vs[len(vs)-1]]) )
        vfollow(ns, pts)
    : // other VCHAMFER_2
        vfollow(vcopy(vsub2(pts),inc=-2), vcopy(pts,1,-1,-2));
