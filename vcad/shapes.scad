/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: shapes.scad
 * Contains module for 3D shapes.
 * Example:
 * > use <vcad/shapes.scad>
 */

include <constants.scad>
include <math.scad>
include <transform.scad>

/**
 * Module: vcad_tube
 * A cylinder with a hole.
 * Tube is centered in Z axis, and depends of 'center' for XY position
 * Parameters:
 *   height      - global cylinder height
 *   radius      - outter radius
 *   thickness   - wall thickness
 *   center      - determine position of the object
 *                 true: center on [0,0,0]
 *                 false: layed on XY plane
 * Example:
 * > vcad_tube(height=10, radius=5, thickness=2);
 */
module vcad_tube(height = 10, radius = 5, thickness = 2, center = false) {
	difference() {
		cylinder(h = height, r = radius, center = center);
		// the hole is epsion bigger
		vcad_tz(-VCAD_EPSILON) {
			cylinder(h=height+2*VCAD_EPSILON, r = radius-thickness, center=center);
		}
	}
}

/**
 * Module: vcad_spherical_cap
 * A spherical cap, ie sphere cut by a plane.
 * Cap is centered in Z axis, and leyed in XY plane.
 * Parameters:
 *   radius - radius of the cap base
 *   height - height of the cap
 * Example:
 * > vcad_spherical_cap(radius=10, height=4);
 */
module vcad_spherical_cap(radius = 10, height = 4) {
	// global sphere radius from parameters
	sphere_radius = (vcad_sq(radius) +vcad_sq(height))/(2*height);
	// a cut sphere
	vcad_tz(-sphere_radius+height) {
		difference() {
			sphere(sphere_radius);
			vcad_tz(-height) {
				cube(2*sphere_radius,true);
			}
		}
	}
}

/**
 * Module: vcad_tore
 * A tore, in Z axis within a max radius <outer> and
 * a <inner> circle radius.
 * Parameters:
 *   outer - external radius
 *   inner - circle radius
 * Example:
 * > vcad_tore(outer=20, inner=2);
 */
module vcad_tore(outer=20, inner=2) {
	rotate_extrude()
		vcad_tx(outer-inner)
			circle(r=inner);
}
