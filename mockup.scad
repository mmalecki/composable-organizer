use <compartment.scad>;
use <lid.scad>;
use <sizing.scad>;
use <utils.scad>;
include <parameters.scad>;

$fn = 50;

lids = true;
compartments = true;

size0 = [2, 3, 1];
size1 = [4, 2, 1];
size2 = [2, 2, 1];

if (compartments) {
  compartment(size0, lid_hinge = true);

  translate([0, outer_y(size0[1]) + 2 * wall_t + fit, 0])
    compartment(size1, lid_hinge = false);

  translate([outer_x(size0[0]) + 2 * wall_t + fit, 0])
    compartment(size2, lid_hinge = true);
}

if (lids) {
  translate([0, 0, size0[2] * u - hinge_i_d / 2])
    to_hinge_x(outer_x(size0[0])) mirror([1, 0]) lid(size0);

  translate([outer_x(size0[0]) + 2 * wall_t + fit, 0, size2[2] * u - hinge_i_d / 2])
    to_hinge_x(outer_x(size0[0])) rotate([0, 10, 0])mirror([1, 0])  lid(size2);
}
