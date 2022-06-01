use <compartment.scad>;
use <lid.scad>;
use <sizing.scad>;
include <parameters.scad>;

$fn = 50;

size0 = [2, 3, 1];
size1 = [4, 2, 1];

compartment(size0, lid_hinge = true);
translate([0, 0, size0[2] * u - hinge_i_d / 2]) lid(size0);

translate([0, outer_y(size0[1]) + 2 * wall_t + fit, 0]) compartment(size1, lid_hinge = false);
