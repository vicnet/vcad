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
 * Constant: VVERSION
 * Current version of vcad library.
 * Vector with year, month and day.
 * Example:
 * > echo("Version: ", VVERSION);
 * Todo: add better use example for VVERSION (test for example)
 */
VVERSION = [2015,11,26];

/**
 * Constants: Version parts
 * VVERSION_YEAR  - year version part (XXXX)
 * VVERSION_MONTH - month version part (1-12)
 * VVERSION_DAY   - day version part (1-31)
 */
VVERSION_YEAR = VVERSION[0];
VVERSION_MONTH = VVERSION[1];
VVERSION_DAY = VVERSION[2];

/**
 * Constant: VVERSION
 * Current version of vcad library in numeric form.
 * Example:
 * > echo("Version: ", VVERSION_NUM);
 * Todo: add better use example for VVERSION_NUM (test for example)
 */
VVERSION_NUM = VVERSION * [100*100, 100, 1];
