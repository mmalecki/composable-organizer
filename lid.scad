use <utils.scad>;
include <parameters.scad>;

module lid (size) {
  w = u * size[1] - 2 * wall_t;
  w_fit = w - fit;
  l = size[0] * u;
  body_l = l + 2 * wall_t - hinge_o_d;

  translate([0, 0, hinge_u - wall_t]) {
    hull () {
      cube([body_l, u * size[1], wall_t]);
      translate([body_l, wall_t + (w - w_fit) / 2])
        cube([hinge_o_d / 2, w_fit, wall_t]);
    }
  }

  translate([body_l + hinge_o_d / 2, (w - w_fit) / 2 + wall_t, -hinge_o_d / 4 + fit / 2]) {
    rotate([270, (360 - lid_hinge_angle) / 2 + 90, 0])
      circle_sleeve(hinge_o_d - fit, w_fit, hinge_wall_t - press_fit - fit / 2, lid_hinge_angle);
  }
}

if (!is_undef(size)) {
  lid(size);
}
