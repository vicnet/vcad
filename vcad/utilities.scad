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

include <params.scad>

/**
 * Function: velem
 * Returns the <pos> element of <list>.
 * Parameters:
 *   list - list to search
 *   pos - element pos
 *   deflt - ??
 *   end - ??
 * Returns:
 *  If <pos> under 0, first elem,
 *  if <pos> >= len(list) last elem,
 *  else element of <list> at <pos>.
 * Example:
 * > velem([1,2],0); // outputs 1
 * > velem([1,2],5); // outputs 2
 */
function velem(list, pos, deflt, end) =
    let(l=vislist(list)?len(list):0
      , e=visdef(end)?end:0
      , pos=vopt(pos,l+e))
    visnum(list)
        ? (pos==0 ? list : vopt(deflt,list))
        : pos<0 ? vopt(deflt,list[0])
        : pos>=l ? vopt(deflt,list[l-1])
        : list[pos];

/**
 * Function: vorder
 * Returns list order of <param>.
 * Assume that <param> is homogeneous,
 * ie that same order for one level.
 * Parameters:
 *   param - scalar, list, vector or matrix.
 * Returns:
 *   A array with list order.
 * Example:
 * > echo(vorder(2)); // outputs [] no order
 * > echo(vorder([1,2,3])); // outputs [3]
 * > echo(vorder([ [1,0],[0,1] ])); // outputs [2,2]
 */
function vorder(param) =
    visnum(param) || visundef(param)
        ? [] // scalar or undef, no order
        : concat([len(param)], vorder(param[0]));

/**
 * Function: vlevel
 * Returns the number of level <param>.
 * Parameters:
 *   param - scalar, list, vector, matrix...
 * Returns:
 *   Number of levels.
 * Example:
 * > echo(vlevel(2)); // outputs 0
 * > echo(vlevel([2])); // outputs 1
 * > echo(vlevel([[2]])); // outputs 2
 */
function vlevel(param) = len(vorder(param));

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
 * Function: vindexes
 * Returns a range from 0 to length of <v>-1 (len(<v>) elements).
 * Use with 'for' buildin.
 * Parameters:
 *   v - scalar or vector (to get len)
 *   inc - increment (element skipped), if negative, multiplier.
 *   start - number of index removed at begining
 *   end - if positive, number of element kept
 *         if negative, number of index removed from end
 * Returns:
 *   A range (or vector like a range) of indexes.
 * Example:
 * > echo(vindexes([1,2])); // outputs [0:1:1]
 * > echo(vindexes([1,2,3],start=1,inc=1,end=-1)); // outputs [1:1:1]
 * > echo(vindexes([1,2],inc=-2)); // outputs [0,0,1,1]
 * > echo(vindexes([1,2,3],1,-1,-2)); // outputs [0,1,1,2]
 */
function vindexes(v, start=0, end=0, inc=1) =
    let (n = visnum(v) ? v : len(v))
    inc>0
        ? let(end = end>0 ? end-1 : n-1+end) [start:inc:end]
        : let(m=-inc, nb = end>0 ? end-1 : n*m+end-1)
          [for (i=[0:n-1]) for(j=[0:m-1])
            let(pos=i*m+j)
            if ((pos>=start) && (pos<=nb)) i];

/**
 * Function: vcopy
 * Returns a copy of <v> with less or duplicate elements.
 * See <vindexes>.
 * Parameters:
 *   v - vector.
 *   inc - increment (element skipped), if negative, multiplier.
 *   start - number of index removed at begining
 *         if negative, start before the end
 *   end - if positive, number of element kept
 *         if negative, number of index removed from end
 * Returns:
 *   A vector copy of <v>.
 * Example:
 * > echo(vcopy([1,2])); // outputs [1,2]
 * > echo(vcopy([1,2,3],start=1,inc=1,end=-1)); // outputs [2]
 * > echo(vcopy([1,2],inc=-2)); // outputs [1,1,2,2]
 * > echo(vindexes([1,2,3],1,-1,-2)); // outputs [1,2,2,3]
 */
function vcopy(vs, start=0, end=0, inc=1) = [
    for (i=vindexes(vs,start,end,inc))
        let(i=i%len(vs))
        i<0 ? vs[len(vs)+i] : vs[i]
    ];

/**
 * Function: vabs
 * Returns absolute value of <v>
 * Parameters:
 *   v - a scalar or list
 * Returns:
 *   A vector of substractions.
 * Example:
 * > echo(vabs([1,-2])); // outputs [1,2]
 */
function vabs(v) =
    visnum(v) ? abs(v) : [ for(i=v) abs(i) ];

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
    for(i=vindexes(l,end=-1)) l[i+1]-l[i] ];

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
    for(i=vindexes(l,end=-1)) l[i]+l[i+1] ];

/**
 * Calculate the linear interpolation at <i> from <a> to <b>.
 * Parameters:
 *   i - position
 *   a - first value (scalar or any)
 *   b - second value (scalar or any)
 * Returns:
 *   A value
 * Example:
 * > echo(vlinear(0.5,1,2)); // outputs 1.5
 * > echo(vlinear(0.5,VX,VY)); // outputs [0.5, 0.5, 0]
 */
function vlinear(i,a,b) = a + (b-a)*i;

/**
 * Calculate the linear interpolation at <i> on 0..<n>
 * from <v>.
 * Parameters:
 *   i - position
 *   v - list of values
 *   n - max number for i
 * Returns:
 *   A value
 * Example:
 * > echo(vlookup(0.5,[1,2])); // outputs 1.5
 * > echo(vlookup(5,[1,2],10)); // outputs 1.5
 */
function vlookup(i,v,n=1) =
    let( pos=(len(v)-1)*i/n, vi=floor(pos), t=pos-vi
       , start=velem(v,vi), end=velem(v,vi+1))
    vlinear(t, start, end);

function v2dto3d(pts, z=0) =
    [ for (pt = pts) [pt.x, pt.y, z] ];

function v3dto2d(pts) =
    [ for (pt = pts) [pt.x, pt.y] ];

/**
 * Inverse a list.
 * Parameters:
 *   l - the list
 * Returns:
 *   An inverted list
 * Example:
 * > echo(vinverse([0,2,4])); // outputs [4,2,0]
 */
function vinverse(l) =
    let(n=len(l))
    [ for(i=[n-1:-1:0]) l[i] ];
