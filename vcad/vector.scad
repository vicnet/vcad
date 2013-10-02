/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: vector.scad
 * Contains vector utilities.
 * Example:
 * > use <vcad/vector.scad>
 */


/**
 * Constant: VCAD_ZERO_VECTORS
 * Array of null vectors (vector with only 0) by dimention size (2 is in plane, 3 is in 3D).
 * Example:
 * > echo("Null vector in 3D is ", VCAD_NULL_VECTORS[3]); // Outputs Null vector in 3D is [0,0,0]
 */
VCAD_NULL_VECTORS = [
		  []
		, [0]
		, [0,0]
		, [0,0,0]
		, [0,0,0,0]
	];

/**
 * Constant: VCAD_UNARY_VECTORS
 * Array of unary vectors (vector with only 1) by dimention size (2 is in plane, 3 is in 3D).
 * Could be useful of vector calculation.
 * Example:
 * > echo("Unary vector in 3D is ", VCAD_UNARY_VECTORS[3]); // Outputs Unary vector in 3D is [1,1,1]
 */
VCAD_UNITARY_VECTORS = [
		  []
		, [1]
		, [1,1]
		, [1,1,1]
		, [1,1,1,1]
		, [1,1,1,1,1]
	];

/**
 * Function: vcad_sum
 * Returns the sum of each vector (or matrix) elements.
 * Remark: size of 'parameter v' is limited to 5 elements.
 * Parameters:
 *   v - a vector or a matrix.
 * Returns:
 *   A scalar, the sum of each elemetns,of a vector, the vectorial sum of each matrix vector.
 *   or undef if dimention is greater than VCAD_UNITARY_VECTORS size.
 * Example:
 * > echo("Sum of [1,1,1,1,1] is ", vcad_sum([1,1,1,1,1])); // Sum of [1,1,1,1,1] is 5
 */
function vcad_sum(v) =
	  len(v)<=len(VCAD_UNITARY_VECTORS)
	? v*VCAD_UNITARY_VECTORS[len(v)]
	: undef;

/**
 * Function: vcad_norm
 * Returns the norm  of a vector.
 * Parameters:
 *   v - vector to norm, any size.
 * Returns:
 *   A scalar, the vector's 'norm.
 * Example:
 * > echo("Norm of [1,1] is ", vcad_norm([1,1])); // outputs Norm of [1,1] is 1.41421
 */
function vcad_norm(v) = sqrt(v*v);

/**
 * Function: vcad_distance
 * Returns the distance of two vectors.
 * Parameters:
 *   a - first vector, any size.
 *   b - second vector, same size as a.
 * Returns:
 *   The vectorial distance from point a to b.
 * Example:
 * > echo("Distance from [0,0] to ][1,1] is ", vcad_distance([[0,0],]1,1])); // outputs Distance from [0,0] to ][1,1] is 1.41421
 */
function vcad_distance(a,b) = vcad_norm(a-b);

/**
 * Function: vcad_rotate2D
 * Rotate a 2D vector with angle
 * Parameters:
 *   a - angle to rotate
 *   v - vetor to rotate
 * Returns:
 *   The rotate vector
 * Example:
 * > echo("90° rotation of [1,0] is ", vcad_rotate2D([1,0])); // outputs 90° rotation of [1,0] is [0,-1]
 */
function vcad_rotate2D(a,v) =
	[ [cos(a), -sin(a)],
	  [sin(a),  cos(a)] ] * v;

