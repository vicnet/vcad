/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2015  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: matrix.scad
 * Contains modules for matrix.
 * Example:
 * > use <vcad/matrix.scad>
 */


/**
 * Function: vmatrix()
 * Returns a matrix with diagonal filled with <v1> and other with <v2>,
 * Example:
 * > echo(vmatrix(3,1)); // outputs [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
 */
function vmatrix(n=3, v1=1, v2=0) = [ for (i=vrange(n)) [
        for (j=vrange(n)) i==j ? v1 : v2 ]
    ];

/**
 * Function: vmnull
 * Returns a empty matrix of size <n> (all 0).
 * Parameters:
 *  n - size of the vector
 * Example:
 * > echo(vmnull(2)); // outputs [[0,0],[0,0]]
 */
function vmnull(n=3) = vmatrix(n,0,0);

/**
 * Function: vmunary
 * Returns a unary matrix of size <n> (all 1).
 * Parameters:
 *  n - size of the vector
 * Example:
 * > echo(vmunary(2)); // outputs [[1,1],[1,1]]
 */
function vmunary(n=3) = vmatrix(n,1,1);

/**
 * Function: vmunit
 * Returns a unity matrix of size <n> (1 in diagonal).
 * Parameters:
 *  n - size of the vector
 * Example:
 * > echo(vmunit(2)); // outputs [[1,0],[0,1]]
 */
function vmunit(n=3) = vmatrix(n,1,0);
