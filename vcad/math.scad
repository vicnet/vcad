/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: math.scad
 * Contains math utilities.
 * Example:
 * > use <vcad/math.scad>
 */

/**
 * Function: vsq
 * Returns square value of a number or a vector.
 * Parameters:
 *   x  - value to find the square.
 * Returns:
 *   The square of x.
 * Example:
 * > echo("square of 2",vsq(2)); // outputs 4
 * > echo("square of [1,1]",vsq([1,1])); // outputs 2, dot-product
 */
function vsq(x) = x*x;
