/*
 * Example:
 * > echo(vsquare(5)); // [[0, 0, 0], [5, 0, 0], [5, 5, 0], [0, 5, 0]]
 * > echo(vsquare([2,3])); //  [[0, 0, 0], [2, 0, 0], [2, 3, 0], [0, 3, 0]]
 * > echo(vsquare([2,3,4])); //  [[0, 0, 4], [2, 0, 4], [2, 3, 4], [0, 3, 4]]
 * > echo(vsquare([2,3,4],z=10)); // [[0, 0, 10], [2, 0, 10], [2, 3, 10], [0, 3, 10]]
*/
function vsquare(size, x, y, z) =
    let (v = vpoint(size,x=x,y=y,z=vopt(z,size.z,0)))
    [ [0,0,v.z], [v.x,0,v.z], [v.x,v.y,v.z], [0,v.y,v.z] ];

function varc(r=1, a=90) =
    let(n = $fn>0.1 ? $fn : 10)
    concat(
          [[0,0]]
        , [for (i=vrange(n+1,0,a/n)) [r*cos(i),r*sin(i)]]
    );
