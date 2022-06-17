use <sizing.scad>;
use <utils.scad>;
include <parameters.scad>;

module tray_lid (size, notch = true) {
  o_x = outer_x(size[0]) + 8 * wall_t + 2 * tray_fit;
  o_y = outer_y(size[1]) + 8 * wall_t + 2 * tray_fit;

  half_fit = tray_lid_fit / 2;

  difference () {
    union () {
      cube([o_x, o_y, tray_wall_t]);
      translate([tray_wall_t + half_fit, tray_wall_t + half_fit, tray_wall_t]) {
        square_sleeve([
          o_x - half_fit - 2 * tray_wall_t,
          o_y - half_fit - 2 * tray_wall_t,
          tray_lid_catch
        ], wall_t);
      }
    }

    if (notch) {
      translate([0, (o_y - notch_w) / 2, tray_wall_t - notch_h]) {
        cube([notch_d, notch_w, notch_h]);
      }
    }
  }
}

if (!is_undef(size)) {
  tray_lid(size, is_undef(notch) ? true : notch);
}
