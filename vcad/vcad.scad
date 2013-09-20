/*
 *  OpenSCAD vcad library (www.openscad.org)
 *  Copyright (C) 2013  Vicnet
 *
 *  License: LGPL 3 or later
 */

/**
 * File: vcad.scad
 * Contains vcad library version defintions.
 * Example:
 * > use <vcad/vcad.scad>
 */

/**
 * Constant: VSCAD_VERSION
 * Current version of vcad library.
 * Example:
 * > echo("Version: ", VSCAD_VERSION);
 * Todo: add better use example for VSCAD_VERSION (test for example)
 */
VSCAD_VERSION = [2013,09,20];

/**
 * Constants: Version parts
 * VSCAD_VERSION_YEAR  - year version part (XXXX)
 * VSCAD_VERSION_MONTH - month version part (1-12)
 * VSCAD_VERSION_DAY   - day version part (1-31)
 */
VSCAD_VERSION_YEAR = VSCAD_VERSION[0];
VSCAD_VERSION_MONTH = VSCAD_VERSION[1];
VSCAD_VERSION_DAY = VSCAD_VERSION[2];

/**
 * Constant: VSCAD_VERSION
 * Current version of vcad library in numeric form.
 * Example:
 * > echo("Version: ", VSCAD_VERSION_NUM);
 * Todo: add better use example for VSCAD_VERSION_NUM (test for example)
 */
VSCAD_VERSION_NUM = VSCAD_VERSION * [100*100, 100, 1];
