/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: transform.scad
 * Contains useful geomerty transformation,
 * based on OpenSCAD transformation primitive.
 * Example:
 * > use <vcad/transform.scad>
 */

/**
 * Module: vcad_tr
 * Translate all children like translate but without vector parameter.
 * Parameters:
 *   x - x translation.
 *   y - y translation.
 *   z - z translation.
 * Example:
 * > vcad_tr(3,5) sphere(10);
 */
module vcad_tr(x,y=0,z=0) {
	translate([x,y,z]) {
		for (i = [0 : $children-1]) {
			child(i);
		}
	}
}

/**
 * Module: vcad_tx
 * Translate all children on X axis from x.
 * Parameters:
 *   x - x translation.
 * Example:
 * > vcad_tx(5) sphere(10);
 */
module vcad_tx(x) {
	translate([x,0,0]) {
		for (i = [0 : $children-1]) {
			child(i);
		}
	}
}

/**
 * Module: vcad_ty
 * Translate all children on Y axis from y.
 * Parameters:
 *   y - y translation.
 * Example:
 * > vcad_ty(5) sphere(10);
 */
module vcad_ty(y) {
	translate([0,y,0]) {
		for (i = [0 : $children-1]) {
			child(i);
		}
	}
}

/**
 * Module: vcad_tz
 * Translate all children on Z axis from z.
 * Parameters:
 *   z - z translation.
 * Example:
 * > vcad_tz(5) sphere(10);
 */
module vcad_tz(z) {
	translate([0,0,z]) {
		for (i = [0 : $children-1]) {
			child(i);
		}
	}
}
/**
 * Module: vcad_rz
 * Rotate children from angle around Z axis.
 * Parameters:
 *   angle - rotation angle
 *   center - rotation center
 * Example:
 * > vcad_rz(-15,[2.5,2.5]) cube([5,5,5]); // rotate around cube center
 */
module vcad_rz(angle, center=undef) {
    translate(center)
        rotate(angle)
            translate(-center) {
                for (i = [0 : $children-1]) {
                    child(i);
                }
            }
}

/**
 * Module: vcad_multiple_spin
 * Duplicate (or multiply) children along a circle centered at [0,0,0] and Z axis.
 * Parameters:
 *   n: number of duplication, must be >= 1.
 * Example:
 * > vcad_duplicate_circle(n=3) translate([10,0]) sphere(2, $fn=40);
 * Todo: transfert duplicate modules in an other scad file ?
 */
module vcad_duplicate_circle(n=3) {
	if (n>=1) {
		for (an=[0:n-1]) {
			rotate(360*an/n) {
				for (i = [0 : $children-1]) {
					child(i);
				}
			}
		}
	} else {
		echo("ERROR: vcad_duplicate_circle: parameter n shoud be greater or equal to 1.");
	}
}

/**
 * Module: vcad_symetric
 * Duplicate children 2 times, around [0,0] and Z axis.
 * Example:
 * > vcad_symetric() translate([10,0]) sphere(2, $fn=40);
 */
module vcad_symetric() {
	vcad_duplicate_circle(2) {
		for (i = [0 : $children-1]) {
			child(i);
		}
	}
}

/**
 * Module: vcad_triple
 * Duplicate children 3 times, around [0,0] and Z axis.
 * Example:
 * > vcad_triple() translate([10,0]) sphere(2, $fn=40);
 */
module vcad_triple() {
	vcad_duplicate_circle(3) {
		for (i = [0 : $children-1]) {
			child(i);
		}
	}
}
