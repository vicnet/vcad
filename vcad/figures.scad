/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: figures.scad
 * Contains modules for 2D figures.
 * Example:
 * > use <vcad/figures.scad>
 */

include <transform.scad>

/**
 * Module: vsquare
 * A square that could be centered in x or y only,
 * and accept negative values for size.
 * <center> is used for <centerx>, <centery> and <centerz> if undefined.
 * <x>,<y> are used first.
 * Then if <size> is a vector, it is completed to a be a 2D vector.
 * If <size> is a scalar, it is used for all dimensions.
 * Else 1 is used as default.
 * Parameters:
 *   size     - 2D vector (could contains negative values) or scalar
 *   center   - boolean, center in x and y (default false)
 *   centerx  - boolean, center in x
 *   centery  - boolean, center in y
 *   x - X value
 *   y - Y value
 * Example:
 * > vsquare(5, centerx=true);
 */
module vsquare(size, center, centerx, centery, x, y) {
    vsize = vpoint(size,x,y);
    vcenter(vsize, center, centerx, centery)
        square(vabs(vsize));
}
