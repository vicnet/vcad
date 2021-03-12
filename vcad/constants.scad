/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: constants.scad
 * Contains useful constants.
 * Import file with 'include', not 'use'
 * (don't import variables from imported file)
 * Example:
 * > include <vcad/constants.scad>
 */

/**
 * Constant: VEPSILON
 * Useful for example for difference() primitive to overlap a little
 * substracted object.
 */ 
VEPSILON = 0.01;

/**
 * Constant: VPI
 * Deprecated: use buildin PI constant
 */
VPI = 3.141592;

/**
 * Constants: axes
 *   VX - X axe vector
 *   VY - Y axe vector
 *   VZ - Z axe vector
 */
VX = [1,0,0];
VY = [0,1,0];
VZ = [0,0,1];

/**
 * Constants: positions
 *   V0 - origin
 */
V0 = [0,0,0];

// unitary vector
V1 = [1,1,1];
