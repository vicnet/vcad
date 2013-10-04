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
 * Module: vcad_blue()
 * Blue color for children,
 * Example:
 * > vcad_blue() square([2,3]);
 */
module vcad_blue() {
	color("blue") {
		for (i = [0 : $children-1]) {
			child(i);
		}
	}
}

