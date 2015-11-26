/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: duplicate.scad
 * Module that duplicate children along a path.
 * Example:
 * > use <vcad/duplicate.scad>
 */

include <constants.scad>
include <multmatrix.scad>
include <path.scad>
include <multpath.scad>


/**
 * Module: vduplicate_simple
 * Duplicate children to follow <path> without change base
 * object normal (translate only).
 * Useful for object without orientation (spherical object).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vduplicate_simple(path, s=1, t=0) {
    vapply(vfollow_simple(path,s,t)) children();
}

/**
 * Module: vduplicate_direct
 * Duplicate children to follow <path> and change normal
 * along <path> (last orientation is in last vector
 * direction).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vduplicate_direct(path, s=1, t=0) {
    vapply(vfollow_direct(path,s,t)) children();
}

/**
 * Module: vduplicate_middle
 * Duplicate children to follow <path> change normal
 * along middle of vector in <path> (first and last
 * orientation direct vector direction).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vduplicate_middle(path, s=1, t=0) {
    vapply(vfollow_middle(path,s,t)) children();
}

/**
 * Module: vduplicate_dup
 * Duplicate children to follow <path> with begin and end
 * of each vector.
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vduplicate_dup(path, s=1, t=0) {
    vapply(vfollow_dup(path,s,t)) children();
}

/**
 * Module: vduplicate_bezier3
 * Duplicate children to follow <path> on bezier curve
 * with 1 control point between position points.
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 * Example:
 * > 
 */
module vduplicate_bezier3(path, s=1, t=0) {
    vduplicate_direct(vbezier3(path),s,t) children();
}

/**
 * Module: vduplicate_bezier4
 * Duplicate children to follow <path> on bezier curve
 * with 2 control points between position points.
 * If weight control <c> is not null, control points
 * are generated with this contraint (default).
 * Parameters:
 *   path - path to follow
 *   s - scale (scalar or vector or list of vector)
 *   t - twist (scalar or vector)
 *   c - weight control
 * Example:
 * > 
 */
module vduplicate_bezier4(path, s=1, t=0, c=0.5) {
    ps = c==0 ? path : vcontrol(path,c);
    vduplicate_direct(vbezier4(ps),s,t) children();
}

/**
 * Module: vduplicate_rot
 * Duplicate children in rotation along Z from
 * 0 to <a> degree.
 * Plane X,Y is reference, and Z is normal.
 * After scale <s>, a first <r> or <d> translation matrix
 * is applied then a rotation matrix around X is applied and
 * then final rotation around Z.
 * $fn could be used.
 * Parameters:
 *   a - final angle
 *   r - translation radius (used first, then <d>)
 *   s - scale, scalar or list of scalar or list of vectors
 *   n - normal to use (default VY)
 * Example:
 * > 
 */
module vduplicate_rot(a=360, r, s=1, d, n=VY) {
    vapply(vfollow_rot(a,r,s,d,n)) children();
}

/**
 * Module: vsymetric
 * Duplicate children 2 times, around VZ.
 * Example:
 * > vsymetric() vtx(10) sphere(2, $fn=40);
 */
module vsymetric() {
    vduplicate_rot(n=VZ, $fn=2) children();
}

/**
 * Module: vtriple
 * Duplicate children 3 times, around VZ.
 * Example:
 * > vtriple() translate([10,0]) sphere(2, $fn=40);
 */
module vtriple() {
    vduplicate_rot(n=VZ, $fn=3) children();
}