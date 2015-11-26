/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: transform.scad
 * Useful geometry transformation modules.
 * Some modules use transformation matrices from <multmatrix.scad>,
 * and define module with smae name.
 * Example:
 * > use <vcad/transform.scad>
 */

include <constants.scad>
include <utilities.scad>
include <multmatrix.scad>


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
    v= vislist(x) ? x : [x,y,z];
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
 * Module: vscale
 * Scale with <s> or [<x>,<y>,<z>].
 * Parameters:
 *   s - global scaling, a scalar, vector (2d or 3d) or list of vector.
 *   x - x scaling.
 *   y - y scaling.
 *   z - z scaling.
 * Example:
 * > 
 */
module vscale(s=1, x=undef, y=undef, z=undef) {
    multmatrix(vscale(s,x,y,z)) children();
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
 * and rotate to <v>.
 * Parameters:
 *   v - normal
 *   p - position
 *   s - scale (scalar)
 *   t - twist (scalar)
 * Example:
 * > 
 */
module vfollow(v, p=V0, s=1, t=0) {
    multmatrix(vfollow(v,p,s,t)) children();
}

/**
 * Module: vcenter
 * Center children from <size>.
 * <size> could be a scalar or a vector.
 * Parameters:
 *   size     - scalar or vector (could contains negative values)
 *   center   - boolean, center in X,Y and Z
 *   centerx  - boolean, center in X
 *   centery  - boolean, center in Y
 * <center> is used for <centerx>, <centery> and <centerz> if undefined.
 * If size is a scalar, use same length fox each dimension.
 * Example:
 * > 
 */
module vcenter(size, center, centerx, centery, centerz) {
    multmatrix(vcenter(size, center, centerx, centery, centerz)) children();
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
    if (vlevel(ms)==2) {
        // one matrix (same as multmatrix)
        multmatrix(ms) children();
    } else {
        for (m=ms) vapply(m) children();
    }
}
