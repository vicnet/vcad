/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: shapes.scad
 * Contains module for 3D shapes.
 * Example:
 * > use <vcad/shapes.scad>
 */

include <constants.scad>
include <utilities.scad>
include <math.scad>
include <points.scad>
include <transform.scad>
include <matrix.scad>


/**
 * Module: vcube
 * A cube that could be centered,
 * and accept negative values for size.
 * <center> is used for <centerx>, <centery> and <centerz> if undefined.
 * <x>,<y>,<z> are used first.
 * Then if <size> is a vector, it is completed to a be a 3D vector.
 * If <size> is a scalar, it is used for all dimensions.
 * Else 1 is used as default.
 * Parameters:
 *   size     - 3D vector (could contains negative values) or scalar
 *   center   - boolean, center in X,Y and Z
 *   centerx  - boolean, center in X
 *   centery  - boolean, center in Y
 *   centerz  - boolean, center in Z
 *   x - X value
 *   y - Y value
 *   z - Z value
 * Example:
 * > vcube(5, centerx=true);
 */
module vcube(size, center, centerx, centery, centerz, x, y, z) {
    vsize = vpoint(size,x,y,z);
    vcenter(vsize, center, centerx, centery, centerz)
        cube(vabs(vsize));
}

/**
 * Module: vcly
 * A cylinder.
 * The cylinder is centered in Z axis, and depends of 'center' for XY position
 * Parameters:
 *   height      - global cylinder height
 *   radius      - outter radius
 *   r1          - bottom outter radius (radius if not set)
 *   r2          - upper outter radius (radius if not set)
 *   center      - determine position of the object
 *                 true: center on [0,0,0]
 *                 false: layed on XY plane
 * Example:
 * > vcyl(height=10, radius=5);
 */
module vcyl(height = 10, radius = 5, r1, r2, center = false) {
    r1 = vopt(r1,radius);
    r2 = vopt(r2,radius);
    cylinder(h=height, r1=r1, r2=r2, center=center);
}

/**
 * Module: vtube
 * A cylinder with a hole.
 * Tube is centered in Z axis, and depends of 'center' for XY position
 * Parameters:
 *   height      - global cylinder height
 *   radius      - outter radius
 *   r1          - bottom outter radius (radius if not set)
 *   r2          - upper outter radius (radius if not set)
 *   thickness   - wall thickness
 *   center      - determine position of the object
 *                 true: center on [0,0,0]
 *                 false: layed on XY plane
 * Example:
 * > vtube(height=10, radius=5, thickness=2);
 */
module vtube(height = 10, radius = 5, thickness = 2, r1, r2, center = false) {
    r1 = vopt(r1,radius);
    r2 = vopt(r2,radius);
    difference() {
        cylinder(h=height, r1=r1, r2=r2, center=center);
        // the hole is epsilon bigger to avoid glitches on cylinder
        vtz(-VEPSILON) {
            cylinder(h=height+2*VEPSILON, r1=r1-thickness, r2=r2-thickness, center=center);
        }
    }
}

/**
 * Module: vspherical_cap
 * A spherical cap, ie sphere cut by a plane.
 * Cap is centered in Z axis, and leyed in XY plane.
 * Parameters:
 *   radius - radius of the cap base
 *   height - height of the cap
 * Example:
 * > vspherical_cap(radius=10, height=4);
 */
module vspherical_cap(radius = 10, height = 4) {
    // global sphere radius from parameters
    sphere_radius = (vsq(radius) +/*v*/vsq(height))/(2*height);
    // a cut sphere
    vtz(-sphere_radius+height) {
        difference() {
            sphere(sphere_radius);
            vtz(-height) {
                cube(2*sphere_radius,true);
            }
        }
    }
}

/**
 * Module: vtore_cap
 * A half tore filled, in Z axis within a max radius <outer> and
 * a <inner> circle radius (champfer).
 * Parameters:
 *   outer - external radius
 *   inner - circle radius
 * Example:
 * > vtore_cap(outer=20, inner=2);
 */
module vtore_cap(outer=20, inner=2) {
    cut_size = (outer+VEPSILON)*2;
    intersection()
    {
        vcube([cut_size, cut_size, inner+VEPSILON], centerx=true, centery=true);
        union() {
            rotate_extrude()
                vtx(outer-inner)
                    circle(r=inner);
            vcyl(inner*2, outer-inner, center=true);
        }
    }
}

/**
 * Module: vtore
 * A tore, in Z axis within a max radius <outer> and
 * a <inner> circle radius.
 * Parameters:
 *   outer - external radius
 *   inner - circle radius
 * Example:
 * > vtore(outer=20, inner=2);
 */
module vtore(outer=20, inner=2) {
    rotate_extrude()
        vtx(outer-inner)
            circle(r=inner);
}

/**
 * Constants: VARROW_D
 * Default value for arrow diameter.
 */
VARROW_D = 0.3;

/**
 * Module: vbase_arrow
 * A arrow with total height of <h> with diameter of <d>
 * and cone height or <a> starting et O and along Z.
 * Parameters:
 *   h - total heigth on Z
 *   d - rod diameter (default: VARROW_D)
 *   cone_h - arrow cone heigth (default: 3*<d>)
 *   cone_d - arrow cone base diameter (default: 2*<d>)
 * Example:
 * > vbase_arrow(10);
 */
module vbase_arrow(h, d=VARROW_D, cone_h=undef, cone_d=undef) {
    cd = vopt(cone_d, d*2); // cone diameter
    ch = min(h, vopt(cone_h, d*3)); // cone heigth
    ih = max(0,h-ch); // intermediate h
    cylinder(ih,d=d);
    vtz(ih) cylinder(ch, d1=cd, d2=0);
}

/**
 * Module: varrow
 * A arrow with total height of <h_v> with diameter of <d>
 * and cone height or <a>. If <h_v> is a integer, it is a
 * height along Z, else along the given vector <h_v>.
 * Parameters:
 *   h_v - total heigth on Z or vector
 *   d - rod diameter (default: 1)
 *   cone_h - arrow cone heigth (default: 3)
 *   cone_d - arrow cone base diameter (default: 2*<d>)
 * Example:
 * > varrow(10);
 */
module varrow(h_v, d=VARROW_D, cone_h=undef, cone_d=undef) {
    if (visnum(h_v)) {
        // scalar
        vbase_arrow(h_v, d, cone_h, cone_d);
    } else {
        h = norm(h_v);
        vrotate(h_v)
            vbase_arrow(h, d, cone_h, cone_d);
    }
}

/**
 * Module: vreinfor
 * A reinforcement brace with an arch.
 * Global size is <size> or <x>/<y>/<z>.
 * Arch is along X axis, and object us under negative Z.
 * Reinforcement can be extended by <e> or <ex>/<ey> on x and y axis.
 * Parameters:
 *   size - global size (without extension)
 *   x - x size (use before size.x)
 *   y - y size (use before size.y)
 *   z - z size (use before size.z)
 *   e - extension in x,y
 *   ex - extension in x (used before e.x)
 *   ey - extension in y (used before e.y)
 * Example:
 * > vreinfor([10,1,5],e=1);
 * openscad --imgsize=500,500 --camera=3,3,-4,70,0,50,40 -o image.png image.scad 
 */
module vreinfor(size, e=0, x,y,z, ex, ez) {
    s = vpoint(size, x, y, z);
    ex = vopt(ex,e);
    ez = vopt(ez,e);
    ns = s+[ex,0,ez];
    vtz(-s.z)
    difference() {
        vtx(-ex)
        vcube(ns,centery=true);
//        resize(s)
        scale([1,1,s.z/s.x])
        vtx(s.x)
        vrx(90) // rotation on XZ plane
        cylinder(h=s.y+VEPSILON*2,r=s.x,$fn=30,center=true);
    }
}

/**
 * Module: vextrude_path
 * Extrude a path along z (or a vector)
 * Parameters:
 *   pts - 2D path
 *   h - z extrusion if number
 *       or a vector
 * Example:
 * > pts = [ [0,0], [0,10], [10,0] ];
 * > vextrude_path(pts,20);
 */
module vextrude_path(pts, h) {
    v = visnum(h) ? [0,0,h] : h;
    n = len(pts);
    points = [ for (p=pts) [p.x,p.y,0]
             , for (p=pts) [p.x,p.y,0]+v
             ];
    faces = [  [ for (i=vindexes(pts)) i ]
            ,  [ for (i=vindexes(pts)) 2*n-i-1 ]
            ,  for (i=vindexes(pts)) [i+n, (i+1)%n+n, (i+1)%n, i]
            ];
    polyhedron(points=points, faces=faces,convexity=1);
}

/**
 * Module: vprism
 * ...
 * Parameters:
 *   size - 2 vectors: base and top
 *   x - x size (use before size.x)
 *   y - y size (use before size.y)
 *   z - z size (use before size.z)
 * Example:
 * > vprism(...);
 */
module vprism(size, center, centerx, centery, centerz, x, y, z) {
    v = vislist(size[0]) ?
          vpoint(size[0],x,y,z)
        : vpoint(size,x,y,z);
    h = vislist(size[1]) ?
          vpoint(size[1],x,y,z)
        : vpoint(size,x,y,z);
    pts = concat(vsquare(v,z=0) // base 0-3
               , [ [0,h.y/2,h.z],[v.x,h.y/2,h.z] ] // triangle 4,5
            );
    fcs = [[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]];
    vcenter(v, center, centerx, centery, centerz)
        polyhedron(points=pts, faces=fcs);
}
