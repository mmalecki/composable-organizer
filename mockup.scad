use <compartment.scad>;
use <lid.scad>;
use <sizing.scad>;
use <utils.scad>;
use <tray.scad>;
use <tray-lid.scad>;
include <parameters.scad>;

$fn = 50;

compartment_color = "yellowgreen";
tray_color = "LemonChiffon";

lids = false;
compartments = true;
tray = true;
tray_lid = true;
explode = true;

e = explode ? 10 : 0;

size0 = [2, 3, 1];
size1 = [4, 2, 1];
size2 = [2, 2, 1];
size_tray = [4, 5, 1];

color(compartment_color) {
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
}

color(tray_color) {
  if (tray) {
    translate([-2 * wall_t, -2 * wall_t, -tray_wall_t])
    tray(size_tray, walls = true);
  }

  if (tray_lid) {
    translate([-3 * wall_t, -3 * wall_t, u + fit + e])
      mirror([0, 0, 1])
        tray_lid(size_tray);
  }
}
