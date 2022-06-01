include <parameters.scad>;

module square_sleeve (size, t) {
  linear_extrude(size[2]) {
    difference () {
      square([size[0], size[1]]);
      translate([t, t]) square([size[0] - 2 * t, size[1] - 2 * t]);
    }
  }
}
module circle_sleeve (o_d, h, t, angle) {
  rotate_extrude (angle = angle) {
    translate([o_d / 2 - t, 0]) square([t, h]);
  }
}

module to_hinge_x(o_x) {
  translate([o_x - hinge_o_d / 2, 0]) children();
}
