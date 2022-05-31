use <compartment.scad>;
use <lid.scad>;
include <parameters.scad>;

$fn = 50;

size = [2, 2, 1];

compartment(size, lid_hinge = true);
// translate([0, -total_u-fit, 0]) compartment(size, lid_hinge = true);
translate([0, 0, size[2] * u - hinge_i_d / 2]) lid(size);
