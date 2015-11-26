vcad library
============

Vicnet OpenSCAD library

Purpose
-------

This is a OpenSCAD library, similar to MCAD, with useful, documented,
tested features (constants, functions or modules).

Contents
--------

### Current version

- vcad
- constants
- shapes
- math
- colors
- figures
- transform
- vector
- matrix
- utilities

### Not yet released
(and never perhaps :-) )

- units
- layout
- multiply

Development
-----------

Each features is:
- documented (with Natural Docs)
- tested (TBD)
- presented with examples

### Terminology

- scalar
- point
- vector
- matrix
- list
- path

### Code rules

Every features start with ~~`vcad_` or `VCAD_`~~ `v` or `V`.
(I hope to introduce namespace in OpenSCAD language one day and then use `vcad` namespace...)
This ovoid conflict with existing library.

A constant is capitalized, and starts with ~~`VCAD_`~~ `V`.
A function or module name is in lowercase, with parts separate by _, and starts with ~~`vcad_`~~`v`.

A file begin with a OpenSCAD version test, that echoes a error message
if OpenSCAD version is too small for one include features.

For usage, a `vcad.scad` provide current vcad library version.

A function or a method should be easy to use but coherent.
It should be valuable by itself and not add extra functionnalties
that could be easely replaced by other method.
Bad example: `cube_translated_and_rotated` could be easely replaced by vtr(...) vrz(...) vcube().

Parameters should be easy to set by user and multi-forms.
Example: if a method need a point, the first param should be a scalar for z pos or a vector.
