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
include <utilities.scad>
include <math.scad>
include <transform.scad>
include <matrix.scad>


/**
 * Module: vsquare
 * A square that could be centered in x or y only,
 * and accept negative values for size.
 * <center> is used for <centerx>, <centery> and <centerz> if undefined.
 * <x>,<y>,<z> are used first.
 * Then if <size> is a vector, it is completed to a be a 3D vector.
 * If <size> is a scalar, it is used for all dimensions.
 * Else 1 is used as default.
 * Parameters:
 *   size     - 2D vector (could contains negative values) or scalar
 *   center   - boolean, center in X,Y and Z
 *   centerx  - boolean, center in X
 *   centery  - boolean, center in Y
 *   x - X value
 *   y - Y value
 *   z - Z value
 * Example:
 * > vsquare(5, centerx=true);
 */
module vcube(size, center, centerx, centery, centerz, x, y, z) {
    vsize = vpoint(size,x,y,z);
    vcenter(vsize, center, centerx, centery)
        cube(vabs(vsize));
}

/**
 * Module: vtube
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
 * > vtube(height=10, radius=5, thickness=2);
 */
module vtube(height = 10, radius = 5, thickness = 2, center = false) {
    difference() {
        cylinder(h = height, r = radius, center = center);
        // the hole is epsion bigger
        vtz(-VEPSILON) {
            cylinder(h=height+2*VEPSILON, r = radius-thickness, center=center);
        }
    }
}

/**
 * Module: vspherical_cap
 * A spherical cap, ie sphere cut by a plane.
 * Cap is centered in Z axis, and leyed in XY plane.
 * Parameters:
 *   radius - radius of the cap base
 *   height - height of the cap
 * Example:
 * > vspherical_cap(radius=10, height=4);
 */
module vspherical_cap(radius = 10, height = 4) {
    // global sphere radius from parameters
    sphere_radius = (vsq(radius) +/*v*/vsq(height))/(2*height);
    // a cut sphere
    vtz(-sphere_radius+height) {
        difference() {
            sphere(sphere_radius);
            vtz(-height) {
                cube(2*sphere_radius,true);
            }
        }
    }
}

/**
 * Module: vtore
 * A tore, in Z axis within a max radius <outer> and
 * a <inner> circle radius.
 * Parameters:
 *   outer - external radius
 *   inner - circle radius
 * Example:
 * > vtore(outer=20, inner=2);
 */
module vtore(outer=20, inner=2) {
    rotate_extrude()
        vtx(outer-inner)
            circle(r=inner);
}

/**
 * Constants: VARROW_D
 * Default value for arrow diameter.
 */
VARROW_D = 0.3;

/**
 * Module: vbase_arrow
 * A arrow with total height of <h> with diameter of <d>
 * and cone height or <a> starting et O and along Z.
 * Parameters:
 *   h - total heigth on Z
 *   d - rod diameter (default: VARROW_D)
 *   cone_h - arrow cone heigth (default: 3*<d>)
 *   cone_d - arrow cone base diameter (default: 2*<d>)
 * Example:
 * > vbase_arrow(10);
 */
module vbase_arrow(h, d=VARROW_D, cone_h=undef, cone_d=undef) {
    cd = vopt(cone_d, d*2); // cone diameter
    ch = min(h, vopt(cone_h, d*3)); // cone heigth
    ih = max(0,h-ch); // intermediate h
    cylinder(ih,d=d);
    vtz(ih) cylinder(ch, d1=cd, d2=0);
}

/**
 * Module: varrow
 * A arrow with total height of <h_v> with diameter of <d>
 * and cone height or <a>. If <h_v> is a integer, it is a
 * height along Z, else along the given vector <h_v>.
 * Parameters:
 *   h_v - total heigth on Z or vector
 *   d - rod diameter (default: 1)
 *   cone_h - arrow cone heigth (default: 3)
 *   cone_d - arrow cone base diameter (default: 2*<d>)
 * Example:
 * > varrow(10);
 */
module varrow(h_v, d=VARROW_D, cone_h=undef, cone_d=undef) {
    if (visnum(h_v)) {
        // scalar
        vbase_arrow(h_v, d, cone_h, cone_d);
    } else {
        h = norm(h_v);
        vrotate(h_v)
            vbase_arrow(h, d, cone_h, cone_d);
    }
}
