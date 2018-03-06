/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2018  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: multmatrix.scad
 * Matrices for 3d transformation.
 * Use with multmatrix buildin module.
 * Modules with same name should be find in <transform.scad>
 * that apply multmatrix to these matrices.
 * Example:
 * > use <vcad/multmatrix.scad>
 */

include <vcad/constants.scad>
include <vcad/utilities.scad>
include <vcad/math.scad> // for vsq
include <vcad/vector.scad>
include <vcad/matrix.scad>


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
    vlevel(x)==0
        ? [ [ 1, 0, 0, x ]
          , [ 0, 1, 0, y ]
          , [ 0, 0, 1, z ]
          , [ 0, 0, 0, 1 ] ]
        : vlevel(x)==1 ?
            vtr(x[0],x[1],x[2])
        : [ for (i=vindexes(x)) vtr(x[i]) ];

/**
 * Function: vtx
 * Returns a translate matrix on X axis from <x>
 * Parameters:
 *   x - x translation.
 * Example:
 * > 
 */
function vtx(x) = vtr(x=x);

/**
 * Function: vty
 * Returns a translate matrix on Y axis from <y>
 * Parameters:
 *   y - y translation.
 * Example:
 * > 
 */
function vty(y) = vtr(y=y);

/**
 * Function: vtz
 * Returns a translate matrix on Z axis from <z>
 * Parameters:
 *   z - z translation.
 * Example:
 * > 
 */
function vtz(z) = vtr(z=z);

/**
 * Function: vrx
 * Returns a rotate matrix from <a> around X axis.
 * Parameters:
 *   a - rotation angle in degree
 * Example:
 * > echo(vrx(-15)); // 
 */
function vrx(a) = 
        [ [ 1,      0,       0, 0 ]
        , [ 0, cos(a), -sin(a), 0 ]
        , [ 0, sin(a),  cos(a), 0 ]
        , [ 0,      0,       0, 1 ] ];

/**
 * Function: vry
 * Returns a rotate matrix from <a> around Y axis.
 * Parameters:
 *   a - rotation angle in degree
 * Example:
 * > echo(vry(-15)); // 
 */
function vry(a) = 
        [ [ cos(a),  0,  sin(a), 0 ]
        , [ 0,       1,       0, 0 ]
        , [ -sin(a), 0,  cos(a), 0 ]
        , [ 0,       0,       0, 1 ] ];

/**
 * Function: vrz
 * Returns a rotate matrix from <a> around Z axis.
 * Parameters:
 *   a - rotation angle in degree
 * Example:
 * > echo(vrz(-15)); // 
 */
function vrz(a) = 
        [ [ cos(a), -sin(a), 0, 0 ]
        , [ sin(a), cos(a),  0, 0 ]
        , [ 0,      0,       1, 0 ]
        , [ 0,      0,       0, 1 ] ];

/**
 * Function: vscale
 * Returns a transformation matrix (or list of matrices)
 * for a scaling with <x>,<y>,<z>.
 * Parameters:
 *   s - global scaling, a scalar, vector (2d or 3d) or list of vector.
 *   x - x scaling.
 *   y - y scaling.
 *   z - z scaling.
 * Returns:
 *   A transformation matrix if parameters are scalar
 *   or <s> a vector.
 *   A list of transformation matrices if <s> is a list.
 * Example:
 * > echo(vscale());
 * > echo(vscale(2));
 * > echo(vscale(x=2));
 * > echo(vscale([2,2]));
 * > echo(vscale([2,2,2]));
 * > echo(vscale([[2,2],[3,3]]));
 */
function vscale(s=1, x, y, z) =
    let(x= vopt(x,s), y=vopt(y,s), z=vopt(z,s))
      vlevel(s)==0 ?
        [ [ x, 0, 0, 0 ]
        , [ 0, y, 0, 0 ]
        , [ 0, 0, z, 0 ]
        , [ 0, 0, 0, 1 ] ]
    : vlevel(s)==1 ?
        vscale(1, s[0],s[1],s[2])
    : // default
        [ for (v=s) vscale(v) ];

/**
 * Function: vskew
 * Returns a transformation matrix skew-symmetric cross product of a vector <v>.
 * See https://en.wikipedia.org/wiki/Skew-symmetric_matrix
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
 * Function: vrotation
 * Returns a transformation matrix to rotate vector <from> onto vetor <to>.
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
    let(to=vnormalize(to), from=vnormalize(from))
    let(c = cross(from, to), sc=vskew(c), nc=norm(c))
        nc<VEPSILON
            ? vmunit(4)
            : vmunit(4)+sc+vsq(sc)*(1-vdot(to,from))/vsq(c); 


/*
 * Internal function
 * Calculate translation for centering or negative value
 */
function _vcenter(v, center) =
    center ? -0.5 * abs(v) : v<0 ? v : 0;

/**
 * Function: vcenter
 * Returns a transformation matrix to center <size>.
 * <size> could be a scalar or a vector.
 * Parameters:
 *   size     - scalar or vector (could contains negative values)
 *   center   - boolean, center in X,Y and Z
 *   centerx  - boolean, center in X
 *   centery  - boolean, center in Y
 *   centerz  - boolean, center in Z
 * <center> is used for <centerx>, <centery> and <centerz> if undefined.
 * If size is a scalar, use same length fox each dimension.
 * Returns:
 *   A transformation matrix.
 * Example:
 * > echo(vcenter([1,2,3])); // outputs  a unit matrix that do nothing
 * > echo(vcenter([-1,-2,3])); // outputs a translation matrix to negate x and y
 * > echo(vcenter([1,2,3],true)); // outputs a translation matrix that divide size
 */
function vcenter(size, center, centerx, centery, centerz) =
    let( vsize = visnum(size) ? [size,size,size] : size
       , centers = vcenters(center, centerx, centery, centerz)
       , vcenter = [ for (i=vindexes(vsize)) _vcenter(vsize[i], centers[i]) ])
    vtr(vcenter);
