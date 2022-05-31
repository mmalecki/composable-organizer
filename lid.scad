use <utils.scad>;
use <sizing.scad>;
include <parameters.scad>;

module lid (size) {
  o_x = outer_x(size[0]);
  o_y = outer_y(size[1]);
  w = o_y - 2 * wall_t;
  w_fit = w - fit;
  l = size[0] * u;
  body_l = l + 2 * wall_t - hinge_o_d;

  translate([0, 0, hinge_u - wall_t]) {
    hull () {
      cube([body_l, outer_y(size[1]), wall_t]);
      translate([body_l, wall_t + (w - w_fit) / 2])
        cube([hinge_o_d / 2, w_fit, wall_t]);
    }
  }

  receptacles = floor(w / hinge_support_step);
  translate([body_l + hinge_o_d / 2, wall_t, -hinge_o_d / 4 + fit / 2]) {
    for (i = [1 : receptacles]) {
      translate([
        0,
        fit / 2 + (i - 1) * (hinge_support_step + wall_t + hinge_support_w / 2 + fit),
        0
      ]) {
        rotate([270, (360 - lid_hinge_angle) / 2 + 90, 0]) {
          circle_sleeve(
            hinge_o_d - fit,
            hinge_support_step - 2 * fit - hinge_support_w / 2 - wall_t,
            hinge_wall_t - press_fit - fit / 2,
            lid_hinge_angle
          );
        }
      }
    }
  }

}

if (!is_undef(size)) {
  lid(size);
}
