/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: constants.scad
 * Contains useful constants.
 * Example:
 * > include <vcad/constant.scad>
 */

/**
 * Constant: VCAD_EPSILON
 * Useful for example for difference() primitive to overlap a little
 * substracted object.
 */ 
VCAD_EPSILON = 0.01;

/// Constant: VCAD_PI
VCAD_PI = 3.141592;

/**
 * Constants: axes
 *   VCAD_X - X axe vector
 *   VCAD_Y - Y axe vector
 *   VCAD_Z - Z axe vector
 */
VCAD_X = [1,0,0];
VCAD_Y = [0,1,0];
VCAD_Z = [0,0,1];
