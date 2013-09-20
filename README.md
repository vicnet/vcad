vcad library
============

Vicnet OpenSCAD library

Purpose
-------

This is a OpenSCAD library, similar to MCAD, with useful, documented,
tested features (constants, functions or modules).

Each features is:
- documented (with Natural Docs)
- tested (TBD)
- presented with example

Code rules
----------

Every features start with `vcad_` or `VCAD_`.
(I hope to introduce namespace in OpenSCAD language one day...)
This ovoid conflict with existing library.

A constant is capitalized, and starts with VCAD_.
A function or module name is in lowercase, with parts separate by _, and starts with `vcad_`.

A file begin with a OpenSCAD version test, that echoes a error message
if OpenSCAD version is too small for one include features.

For usage, a `vcad.scad` provide current vcad library version.

Contents
--------

### Current version

- vcad
- constants
- shapes

### Not yet released
(and never perhaps :-) )

- utilities
- units
- constants
- math
- layout
- multiply
- tranform
- vector
- matrix
