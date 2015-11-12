/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: transform.scad
 * Contains useful geomerty transformation modules.
 * Some modules use transformation matrices from <multmatrix.scad>,
 * and define module with smae name.
 * Example:
 * > use <vcad/transform.scad>
 */

include <constants.scad>
include <utilities.scad>


/**
 * Module: vtr
 * Translate all children like translate but without vector parameter.
 * Parameters:
 *   x - x translation, a scalar or vector.
 *   y - y translation.
 *   z - z translation.
 * If first parameter (<x>) is a vector, same as buildin translate.
 * Example:
 * > vtr(3,5) sphere(10);
 * Todo: if first parameter is a 2d vector, use second param or <z> as thirt coordinate
 */
module vtr(x=0, y=0, z=0) {
    v= visvect(x) ? x : [x,y,z];
    translate(v) children();
}

/**
 * Module: vtx
 * Translate all children on X axis from <x>.
 * Parameters:
 *   x - x translation.
 * Example:
 * > vtx(5) sphere(10);
 */
module vtx(x) {
    translate([x,0,0]) children();
}

/**
 * Module: vty
 * Translate all children on Y axis from <y>.
 * Parameters:
 *   y - y translation.
 * Example:
 * > vty(5) sphere(10);
 */
module vty(y) {
    translate([0,y,0]) children();
}

/**
 * Module: vtz
 * Translate all children on Z axis from <z>.
 * Parameters:
 *   z - z translation.
 * Example:
 * > vvtz(5) sphere(10);
 */
module vtz(z) {
    translate([0,0,z]) children();
}
/**
 * Module: vrz
 * Rotate children from <angle> around Z axis.
 * if <center> is defined, rotate around this point.
 * Parameters:
 *   angle - rotation angle
 *   center - rotation center (default undef)
 * Example:
 * > vrz(-15,[2.5,2.5]) cube([5,5,5]); // rotate around cube center
 */
module vrz(angle, center=undef) {
    translate(center)
        rotate(angle)
            translate(-center) 
                children();
}

/**
 * Module: vduplicate_circle
 * Duplicate (or multiply) children <n> times
 * along a circle centered at [0,0,0]
 * and an axis <axe> (Z by default).
 * Parameters:
 *   n: number of duplication, must be >= 1.
 *   axe - symetry axe (default: Z)
 * Example:
 * > vduplicate_circle(n=3) translate([10,0]) sphere(2, $fn=40);
 * Todo: transfert duplicate modules in an other scad file ?
 */
module vduplicate_circle(n=4, axe=VZ) {
    if (n>=1) {
        for (an=vrange(n)) {
            rotate(360*an/n, axe)
                children();
        }
    } else {
        echo("ERROR: vduplicate_circle: parameter n shoud be greater or equal to 1.");
    }
}

/**
 * Module: vsymetric
 * Duplicate children 2 times, around [0,0]
 * and an axis <axe> (Z by default).
 * Parameter:
 *   axe - symetry axe (default: Z)
 * Example:
 * > vsymetric() translate([10,0]) sphere(2, $fn=40);
 */
module vsymetric(axe=VZ) {
    vduplicate_circle(n=2, axe=axe) children();
}

/**
 * Module: vtriple
 * Duplicate children 3 times, around [0,0]
 * and axis <axe> (Z by default).
 * Parameter:
 *   axe - symetry axe (default: Z)
 * Example:
 * > vtriple() translate([10,0]) sphere(2, $fn=40);
 */
module vtriple(axe=VZ) {
    vduplicate_circle(n=3, axe=axe) children();
}

/**
 * Module: vrotate
 * Rotate children by an angle determined two vectors.
 * Parameter:
 *   to - target vector
 *   from - base vector (default Z)
 * Example:
 * > 
 */
module vrotate(to, from=VZ) {
    multmatrix(vrotate(to,from)) children();
}

/**
 * Module: vfollow
 * Move children to <p>
 * and rotate normal <n> to <v>.
 * Parameters:
 *   v - normal
 *   p - position
 *   n - reference normal vector
 * Example:
 * > 
 */
module vfollow(v, p=V0, n=VZ) {
    multmatrix(vfollow(v,p,n)) children();
}

/**
 * Module: vapply
 * Apply transformation matrices to children.
 * Parameters:
 *   ms - list of matrices.
 * Example:
 * > 
 */
module vapply(ms) {
    for (m=ms) multmatrix(m) children();
}

/**
 * Module: vhull2
 * Hull transformed children 2 by 2.
 * Parameters:
 *   ms - list of matrices.
 *   chamfer - hull intermediate chamfer.
 * Example:
 * > 
 */
module vhull2(ms, chamfer=true) {
    skip = chamfer ? 1 : 2;
    for ( i = [ 0 : skip : len(ms)-2 ] )
        hull() {
            multmatrix(ms[i]) children();
            multmatrix(ms[i+1]) children();
        }
}

/**
 * Module: vextrude
 * Extrude along <pts>.
 * Parameters:
 *   pts - path to follow
 *   chamfer - chamfer type (default fill)
 * Returns:
 *   A list of transformation matrix.
 * Example:
 * > l=[V0,VX,VX+VY]*5
 * > vextrude(l,VCHAMFER_NO) sphere(1,$fn=15);
 * > vextrude(l,VCHAMFER_MID) cylinder(h=0.1,d=1);
 * > vextrude(l,VCHAMFER_2_EMPTY) cylinder(h=0.1,d=1);
 * > vextrude(l,VCHAMFER_2_FILL) cylinder(h=0.1,d=1);
 */
module vextrude(pts, chamfer=VCHAMFER_2_FILL) {
    vhull2(vextrude(pts,chamfer), chamfer!=VCHAMFER_2_EMPTY) children();
}
