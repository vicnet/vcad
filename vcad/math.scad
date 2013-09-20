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
 * Function: sq
 * Returns square value of a number or a vector.
 * Parameters:
 *   x  - value to find the square.
 * Returns:
 *   Tthe square of x.
 * Example:
 * echo("square of 2",vcad_sq(2)); // outputs 4
 * echo("square of [1,1]",vcad_sq([1,1])); // outputs 2, dot-product
 */
function vcad_sq(x) = x*x;
