/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2015  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: path.scad
 * Function to manipulate path (list of points).
 * Example:
 * > use <vcad/path.scad>
 */

include <vcad/utilities.scad>


/**
 * Function: vbezier3_pt
 * Returns a point along bezier curve at <t> with points <ps>
 * after <start>.
 * Result is <ps[start]> if <t> is 0.
 * Result is <ps[start+2]> if <t> is 1.
 * <ps[start+1]> is a control point.
 * Parameters:
 *   ps - path
 *   t - position os result point
 *   start - first point to use in path
 * Returns:
 *   A point.
 * Example:
 * > 
 */
function vbezier3_pt(ps, t, start=0) =
    vsq(1-t)*ps[start]+2*t*(1-t)*ps[start+1]+vsq(t)*ps[start+2];

/**
 * Function: vbezier3_pts
 * Returns <n> points along bezier curve with points <ps>
 * after <start>.
 * Result starts at <ps[start]> and end at <ps[start+2]>.
 * <ps[start+1]> is a control point.
 * Parameters:
 *   ps - path
 *   n - number of point to generate.
 *   start - first point to use in path
 * Returns:
 *   A list of point.
 * Example:
 * > 
 */
function vbezier3_pts(ps, n, b=0, start=0) = [
    for (i=[b:n]) let(t=i/n)
        vbezier3_pt(ps,t,start) ];

/**
 * Function: vbezier3
 * Returns points along bezier curve with points <ps>.
 * Result starts at first point of <ps> and end at last
 * point of <ps>
 * 1 central point on 3 is a control point.
 * $fn is used to calculate the number of iteration (default 10).
 * Parameters:
 *   ps - path
 * Returns:
 *   A list of point.
 * Example:
 * > 
 */
function vbezier3(ps) =
    let(n = $fn<=0 ? 10 : $fn)
    [ for (i=vindexes(ps,inc=2,end=-1))
        for (pt=vbezier3_pts(ps, n, i==0?0:1, i)) pt ];

/**
 * Function: vbezier4_pt
 * Returns a point along bezier curve at <t> with points <ps>
 * after <start>.
 * Result is <ps[start]> if <t> is 0.
 * Result is <ps[start+3]> if <t> is 1.
 * <ps[start+1]> and <ps[start+2]> are a control points.
 * Parameters:
 *   ps - path
 *   t - position os result point
 *   start - first point to use in path
 * Returns:
 *   A point.
 * Example:
 * > 
 */
function vbezier4_pt(ps, t, start=0) =
    pow(1-t,3)*ps[start]+3*t*vsq(1-t)*ps[start+1]+3*vsq(t)*(1-t)*ps[start+2]+pow(t,3)*ps[start+3];

/**
 * Function: vbezier4_pts
 * Returns <n> points along bezier curve with points <ps>
 * after <start>.
 * Result starts at <ps[start]> and end at <ps[start+3]>.
 * <ps[start+1]> and <ps[start+2]> are a control points.
 * Parameters:
 *   ps - path
 *   n - number of point to generate.
 *   start - first point to use in path
 * Returns:
 *   A list of point.
 * Example:
 * > 
 */
function vbezier4_pts(ps, n, b=0, start=0) = [
    for (i=[b:n]) let(t=i/n)
        vbezier4_pt(ps,t,start) ];

/**
 * Function: vbezier4
 * Returns points along bezier curve with points <ps>.
 * Result starts at first point of <ps> and end at last
 * point of <ps>
 * 2 central points on 4 are control points.
 * $fn is used to calculate the number of iteration (default 10).
 * Parameters:
 *   ps - path
 * Returns:
 *   A list of point.
 * Example:
 * > 
 */
function vbezier4(ps) =
    let(n = $fn<=0 ? 10 : $fn)
    [ for (i=vindexes(ps,inc=3,end=-1))
        for (pt=vbezier4_pts(ps,n,i==0?0:1,i)) pt ];

/**
 * Function: vcontrol_pt
 * Returns a control point along vector issued from
 * <ps> (ps[start],ps[start+2]) at position <t>
 * and applied to ps[start+1].
 * <c> defines constraint applied to vector.
 * Parameters:
 *   ps - path
 *   t - position
 *   start - first point
 * Returns:
 *   A point.
 * Example:
 * > 
 */
function vcontrol_pt(ps, t=1, start=0) =
    ps[start+1]+(ps[start+2]-ps[start])/2*t;

/**
 * Function: vcontrol_pts
 * Returns control points at point <ps[start+1]>
 * from <ps> corresponding to vector
 * <(ps[start],ps[start+2])> before and after point.
 * <c> defines weigth constraint applied to vectors.
 * Parameters:
 *   ps - path
 *   start - first point
 *   c - weigth constraint (0 for no control points)
 * Returns:
 *   Conrol points and middle point inside.
 * Example:
 * > 
 */
function vcontrol_pts(ps, start=0, c=0.5) = [
    for (t=[-1:1])
        vcontrol_pt(ps,t*c,start) ];

/**
 * Function: vcontrol
 * Returns control points on each point of <ps>.
 * <c> defines constraint applied to vectors.
 * Remark: to be used with bezier curve.
 * Parameters:
 *   ps - path
 *   t - position
 *   c - weigth constraint
 * Returns:
 *   <ps> with control points.
 * Example:
 * > 
 */
function vcontrol(ps, c=0.5) =
    let( first = ps[0], last= velem(ps,end=-1) )
    concat( [first, first]
          , [ for (i=vindexes(ps,start=1,end=-1))
                for (pt=vcontrol_pts(ps, i-1, c)) pt ]
          , [last, last]);
