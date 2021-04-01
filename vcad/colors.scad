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

/**
 * Module: vred()
 * Red color for children,
 * Example:
 * > vred() square([2,3]);
 */
module vred() {
    color("red") children();
}

/**
 * Module: vwhite()
 * White color for children,
 * Example:
 * > vwite() square([2,3]);
 */
module vwhite() {
    color("white") children();
}

/**
 * Module: vgray()
 * Gray color for children,
 * Example:
 * > vgray() square([2,3]);
 */
module vgray() {
    color("gray") children();
}
