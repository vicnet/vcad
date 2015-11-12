/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: utilities.scad
 * Contains utilities.
 * Example:
 * > use <vcad/utilities.scad>
 */

/**
 * Function: vopt
 * Returns the value or default value for an optional parameter.
 * Parameters:
 *   param - parameter to test.
 *   deflt - default value.
 * Returns:
 *   If <param> is undef returns <deflt> value else returns itself.
 * Example:
 * > vopt(param,5) // outputs 5
 * > vopt(10,5) // outputs 10
 */
function vopt(param,deflt) = param==undef ? deflt : param;

/**
 * Function: visvect
 * Returns if <param> is a vector or not.
 * Parameters:
 *   param - parameter to test.
 * Returns:
 *   A boolean.
 * Example:
 * > echo(visvect(5)); // outputs false
 * > echo(visvect([5])); // outputs true
 */
function visvect(param) = len(param)!=undef;

/**
 * Function: visnum
 * Returns if <param> is a number or not (not a vector).
 * Parameters:
 *   param - parameter to test.
 * Returns:
 *   A boolean.
 * Example:
 * > echo(visnum(5)); // outputs true
 * > echo(visnum([5])); // outputs false
 */
function visnum(param) = !visvect(param);

/**
 * Function: vorder
 * Returns list order of <n>.
 * Assume that <m> is homogeneous,
 * ie that same order for one level.
 * Parameters:
 *   n - scalar, list, vector or matrix.
 * Returns:
 *   A array with list order.
 * Example:
 * > echo(vorder(2)); // outputs [] no order
 * > echo(vorder([1,2,3])); // outputs [3]
 * > echo(vorder([ [1,0],[0,1] ])); // outputs [2,2]
 */
function vorder(n) =
    len(n)==undef ?
          [] // scalar, no order
        : concat([len(n)], vorder(n[0]));

/**
 * Function: vlevel
 * Returns the number of level <n>.
 * Parameters:
 *   n - scalar, list, vector, matrix...
 * Returns:
 *   Number of levels.
 * Example:
 * > echo(vlevel(2)); // outputs 0
 * > echo(vlevel([2])); // outputs 1
 * > echo(vlevel([[2]])); // outputs 2
 */
function vlevel(n) = len(vorder(n));

/**
 * Function: vrange
 * Returns a range from 0 to <nb>-1 (<nb> elements).
 * Use with 'for' buildin.
 * Parameters:
 *   nb - number of items in range (not end).
 *   start - starting value.
 *   inc - increment value (default: 1)
 * Returns:
 *   A range with exactly <nb> elements..
 * Example:
 * > echo(vrange(2)); // outputs [0:1:1]
 */
function vrange(nb, start=0, inc=1) =
    [start:inc:start+inc*(nb-1)];

/**
 * Function: vindex
 * Returns a range from 0 to length of <v>-1 (len(<v>) elements).
 * Use with 'for' buildin.
 * Parameters:
 *   v - vector.
 *   inc - increment (element skipped), if negative, multiplier.
 *   start - number of index removed at begining
 *   end - if positive, number of element kept
 *         if negative, number of index removed from end
 * Returns:
 *   A range (or vector like a range) of indexes.
 * Example:
 * > echo(vindex([1,2])); // outputs [0:1:1]
 * > echo(vindex([1,2,3],start=1,inc=1,end=-1)); // outputs [1:1:1]
 * > echo(vindex([1,2],inc=-2)); // outputs [0,0,1,1]
 * > echo(vindex([1,2,3],1,-1,-2)); // outputs [0,1,1,2]
 */
function vindex(v, start=0, end=0, inc=1) =
    inc>0 ?
          let(end = end>0 ? end-1 : len(v)-1+end) [start:inc:end]
        : let(m=-inc, nb = end>0 ? end-1 : len(v)*m+end-1)
          [for (i=[0:len(v)-1]) for(j=[0:m-1])
            let(pos=i*m+j)
            if ((pos>=start) && (pos<=nb)) i];

/**
 * Function: vcopy
 * Returns a copy of <v> with less or duplicate elements.
 * See <vindex>.
 * Parameters:
 *   v - vector.
 *   inc - increment (element skipped), if negative, multiplier.
 *   start - number of index removed at begining
 *   end - if positive, number of element kept
 *         if negative, number of index removed from end
 * Returns:
 *   A vector copy of <v>.
 * Example:
 * > echo(vcopy([1,2])); // outputs [1,2]
 * > echo(vcopy([1,2,3],start=1,inc=1,end=-1)); // outputs [2]
 * > echo(vcopy([1,2],inc=-2)); // outputs [1,1,2,2]
 * > echo(vindex([1,2,3],1,-1,-2)); // outputs [1,2,2,3]
 */
function vcopy(vs, start=0, end=0, inc=1) = [
    for (i=vindex(vs,start,end,inc)) vs[i] ];

/**
 * Function: vsub2
 * Returns a vector of substration of <l> 2 by 2.
 * Could be use to calculate vectors from points.
 * Parameters:
 *   l - list.
 * Returns:
 *   A vector of substractions.
 * Example:
 * > echo(vsub2([1,2])); // outputs [1]
 */
function vsub2(l) = [
    for(i=vindex(l,end=-1)) l[i+1]-l[i] ];

/**
 * Function: vsum2
 * Returns a vector of additions of <l> 2 by 2.
 * Could be use to calculate middle normal of vectors.
 * Parameters:
 *   l - list.
 * Returns:
 *   A vector of additions.
 * Example:
 * > echo(vsum2([[1,1],[3,3]])/2); // outputs [[2,2]]
 */
function vsum2(l) = [
    for(i=vindex(l,end=-1)) l[i]+l[i+1] ];
