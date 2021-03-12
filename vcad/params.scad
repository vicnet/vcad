/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: parms.scad
 * Contains parameter management utilities.
 * Example:
 * > use <vcad/params.scad>
 */


/**
 * Function: vopt
 * Returns the value or default value for an optional parameter.
 * Helper for parameters management.
 * Parameters:
 *   param - parameter to test.
 *   default - default value.
 * Returns:
 *   If <param> is defined returns itself.
 *   else returns fir defined value.
 * Example:
 * > vopt(undef,5) // outputs 5 (param is undef)
 * > vopt(10,5) // outputs 10
 */
function vopt(param, def1, def2, def3) =
      param!=undef ? param
    : def1 !=undef ? def1
    : def2 !=undef ? def2
    : def3;

/**
 * Function: vpoint
 * Returns the vector from <size> or position <x>,<y>,<z>.
 * Helper for parameters management.
 * <x>,<y>,<z> are used first.
 * Then if <size> is a vector, it is completed to a be a 3D vector.
 * If <size> is a scalar, it is used for all dimensions.
 * Else 1 is used as default.
 * Parameters:
 *   size - default size for dimension, scalar or vector
 *   x - X value
 *   y - Y value
 *   z - Z value
 * Returns:
 *   A vector in 3D.
 * Example:
 * > echo(vpoint(5)); // outputs [5,5,5]
 * > echo(vpoint(5,x=4)); // outputs [4,5,5]
 * > echo(vpoint(y=5); // outputs [1,5,1]
 */
function vpoint(size, x, y, z) =
    let(n=visnum(size) ? size : undef)
    [ vopt(x, size[0], n, 1)
    , vopt(y, size[1], n, 1)
    , vopt(z, size[2], n, 1) ];

/**
 * Function: vcenters
 * Returns a boolean center vector, with default value.
 * Helper for parameters management.
 * Parameters:
 *   center   - boolean, center in X,Y and Z
 *   centerx  - boolean, center in X
 *   centery  - boolean, center in Y
 *   centerz  - boolean, center in Z
 * <center> is used for <centerx>, <centery> and <centerz> if undefined.
 */
function vcenters(center=false, centerx, centery, centerz) =
    let(center = vopt(center,false))
    [ vopt(centerx,center), vopt(centery,center), vopt(centerz,center) ];

/**
 * Function: visdef
 * Returns if <param> is defined.
 * Parameters:
 *   param - parameter to test.
 * Returns:
 *   A boolean.
 * Example:
 * > echo(visdef(undef)); // outputs false
 * > echo(visdef(5)); // outputs true
 * > echo(visdef([5])); // outputs true
 */
function visdef(param) = !is_undef(param);

/**
 * Function: visundef
 * Returns if <param> is not defined.
 * Parameters:
 *   param - parameter to test.
 * Returns:
 *   A boolean.
 * Example:
 * > echo(visundef(undef)); // outputs true
 * > echo(visundef(5)); // outputs false
 * > echo(visundef([5])); // outputs false
 */
function visundef(param) = is_undef(param);

/**
 * Function: vislist
 * Returns if <param> is a vector or not.
 * Parameters:
 *   param - parameter to test.
 * Returns:
 *   A boolean.
 * Example:
 * > echo(vislist(5)); // outputs false
 * > echo(vislist([5])); // outputs true
 */
function vislist(param) = visdef(param) && is_list(param);

/**
 * Function: visnum
 * Returns if <param> is a number or not (not a vector).
 * Parameters:
 *   param - parameter to test.
 * Returns:
 *   A boolean.
 * Example:
 * > echo(visnum(5)); // outputs true
 * > echo(visnum([5])); // outputs false
 */
function visnum(param) = visdef(param) && is_num(param);
