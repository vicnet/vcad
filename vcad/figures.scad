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


/**
 * Module: vcad_square
 * A square that could be centered in x or y only,
 * and accept negative values for size.
 * Parameters:
 *   size     - 2D vector (could contains negative values)
 *   center   - boolean, center in x and y
 *   centerx  - boolean, center in x
 *   centery  - boolean, center in y
 * If center is defined, centerx and centery are ignored.
 * Example:
 * > vcad_square(5, centerx=true);
 */
module vcad_square(size=[2,3], center = undef, centerx = false, centery = false) {
	// translation matrix
	mat = [ [centerx?1:0,0] , [0,centery?1:0] ];
	// result translation for center the square
	trans = - mat * size / 2;
	// normalize size
	nsize = [ [size[0]<0 ? -1 : 1, 0], [0, size[1]<0 ? -1 : 1]] * size;
	ntrans = [ [size[0]<0 ? 1 : 0, 0], [0, size[1]<0 ? 1 : 0]] * size;
	if (center==true) {
		// nothing to do, just use normalized size
		square(nsize,true);
	} else if (center==false) {
		// translate for normalized size
		translate(ntrans)
			square(nsize,center);
	} else {
		translate(ntrans)
			translate(trans)
				square(nsize,center=false);
	}
}
