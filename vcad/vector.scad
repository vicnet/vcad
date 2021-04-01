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
 * Function: vvect
 * Return a new vector of size <n> with same values <v1>.
 * If <pos> is defined, set <v1> only at <pos>
 * and set <v2> in other positions. 
 * Parameters:
 *  n   - size of the vector
 *  v1  - a value (scalar or anything else)
 *  pos - index where <v1> will be set
 *  v2  - value used to fill empty rooms
 * Example:
 * > echo(vvect(5,0)); // [0,0,0,0,0]
 * > echo(vvect(4,2,3)); // [0,0,0,2]
 */
function vvect(n=3, v1=1, pos=undef, v2=0) =
    pos==undef ? [ for (i = vrange(n)) v1 ]
               : [ for (i = vrange(n)) i==pos ? v1 : v2 ];

/**
 * Constant: VNULL_VECTORS
 * Array of null vectors (vector with only 0) by dimention size (2 is in plane, 3 is in 3D).
 * Example:
 * > echo(VNULL_VECTORS[3]); // outputs [0,0,0]
 */
VNULL_VECTORS = [
          []
        , [0]
        , [0,0]
        , [0,0,0]
        , [0,0,0,0]
    ];

/**
 * Function: vvnull
 * Return a null vector of size <n>.
 * Parameters:
 *  n - size of the vector
 * Example:
 * > echo("vvnull(5)); // [0,0,0,0,0]
 */
function vvnull(n) = vvect(n,0);

/**
 * Constant: VUNARY_VECTORS
 * Array of unary vectors (vector with only 1) by dimention size (2 is in plane, 3 is in 3D).
 * Could be useful of vector calculation.
 * Example:
 * > echo("Unary vector in 3D is ", VUNARY_VECTORS[3]); // Outputs Unary vector in 3D is [1,1,1]
 */
VUNITARY_VECTORS = [
          []
        , [1]
        , [1,1]
        , [1,1,1]
        , [1,1,1,1]
        , [1,1,1,1,1]
    ];

/**
 * Function: vvunary
 * Return a unary vector of size n (all 1).
 * Parameters:
 *  n - size of the vector
 * Example:
 * > echo("vvunary(5)); // [1,1,1,1,1]
 */
function vvunary(n=3) = vvect(n,1);

/**
 * Function: vvunit
 * Return a vector of size <n> with a one at <pos>.
 * Parameters:
 *  n - size of the vector
 *  pos - position of one (0 based)
 * Example:
 * > echo(vvunit(5)); // [0,1,0,0,0]
 */
function vvunit(n=3,pos=0) = vvect(n,1,pos,0);

/**
 * Fucntion: vvset
 * Set an element of <v> with <x>.
 * If <x> is a vector, len(<x>) elements of v
 * are set by each elements of <x>.
 * Parameters:
 *   v - base vector
 *   e - scalar or vector
 *   pos - position where <x> is set
 * Returns:
 *   v with elements replaced.
 * Example:
 * > echo(vvset([0,0],1)); // outputs [1,0]
 * > echo(vvset([0,0,0],[1,2],1)); // outputs [0,1,2]
 */
function vvset(v, e, pos=0) =
    visnum(e)
        ? [ for (i=vindexes(v)) i==pos ? e : v[i] ]
        : [ for (i=vindexes(v)) (i>=pos && i<pos+len(e)) ? e[i-pos] : v[i] ];

/**
 * Fucntion: vvget
 * Get an element of <v> at <pos>.
 * Parameters:
 *   v - base vector
 *   pos - scalar, even negative
 * Returns:
 *   element at <pos>
 * Example:
 * > echo(vvget([0,2,4],-1)); // outputs 4
 */
    
function vvget(v, pos=0) =
    let(n=len(v), p=pos%n)
    v[(p+n)%n];

/**
 * Function: vsum
 * Returns the sum of each vector (or matrix) elements.
 * Remark: size of 'parameter v' is limited to 5 elements.
 * Parameters:
 *   v - a vector or a matrix.
 * Returns:
 *   A scalar, the sum of each elemetns,of a vector, the vectorial sum of each matrix vector.
 *   or undef if dimention is greater than VUNITARY_VECTORS size.
 * Example:
 * > echo("Sum of [1,1,1,1,1] is ", vsum([1,1,1,1,1])); // Sum of [1,1,1,1,1] is 5
 */
function vsum(v) = v*vvunary(len(v));

/**
 * Function: vnorm
 * Returns the norm  of a vector.
 * Parameters:
 *   v - vector to norm, any size.
 * Returns:
 *   A scalar, the vector's norm.
 * Example:
 * > echo("Norm of [1,1] is ", vnorm([1,1])); // outputs Norm of [1,1] is 1.41421
 * Deprecated: use buildin 'norm' function.
 */
function vnorm(v) = sqrt(v*v);

/**
 * Function: vdistance (vcad_dist)
 * Returns the distance of two vectors.
 * Parameters:
 *   a - first vector, any size.
 *   b - second vector, same size as a.
 * Returns:
 *   The vectorial distance from point a to b.
 * Example:
 * > echo(vdistance([[0,0],]1,1])); // outputs 1.41421
 */
function vdistance(a,b) = norm(a-b);
function vdist(a,b) = norm(a-b);

/**
 * Function: vdot
 * Returns the dot product of 2 vectors.
 * Parameters:
 *   a - first vector, any size.
 *   b - second vector, same size as a.
 * Remarks: just a alias to * operator.
 * Example:
 * > echo(vdot([1,1], [2,2])); outputs 4
 */
function vdot(a,b) = a*b;

/**
 * Determinant
 */
function vdet(a,b) = a.x*b.y-a.y*b.x;

/**
 * Function: vnormalize
 * Returns vector normlized.
 * Parameters:
 *   v - vector, any size, to be normalized..
 * Example:
 * > echo(vnormalize([1,1]); outputs [0.707107, 0.707107]
 */
function vnormalize(v) = v/norm(v);

/**
 * Function: vrotate2d
 * Returns a 2D rotate matrix with angle
 * Usage: `vrotate2d(a)*v`
 * Parameters:
 *   a - angle to rotate
 * Returns:
 *   The rotate 2D matrix
 * Example:
 * > echo("90° rotation of [1,0] is ", vrotate2d(90)*[1,0]); // outputs 90° rotation of [1,0] is [0,-1]
 */
function vrotate2d(a) =
    [ [cos(a), -sin(a)],
      [sin(a),  cos(a)] ];
