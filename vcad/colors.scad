/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: colors.scad
 * Contains modules for colors.
 * Example:
 * > use <vcad/colors.scad>
 */


/**
 * Module: vblue()
 * Blue color for children,
 * Example:
 * > vblue() square([2,3]);
 */
module vblue() {
    color("blue") children();
}
