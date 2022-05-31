use <utils.scad>;
use <sizing.scad>;
include <parameters.scad>;

module receptacle (o_y, h) {
  square_sleeve([receptacle_d, o_y, h], wall_t);
}

module hinge_supports (i_y) {
  supports = floor(i_y / (hinge_support_step + hinge_support_w));
  if (supports > 0) {
    for (i = [1 : supports]) {
      translate([0, -hinge_support_w / 2 + i * hinge_support_step + (i - 1) * (2 * wall_t), 0])
        rotate([0, 135, 0])
          cube([hinge_support_t, hinge_support_w, sqrt(pow(hinge_o_d, 2) * 2) / 2]);
    }
  }
}

module hinge (i_y) {
  // Hinge bridge:
  translate([0, wall_t, 0]) {
    rotate([270, 0, 0]) cylinder(d = hinge_i_d, h = i_y);
    hinge_supports(i_y);
  }
}

module insert (o_z, bridge_h) {
  x_fit = loose_fit;
  y_fit = loose_fit;
  insert_w = u - 2 * wall_t - y_fit;

  translate([0, y_fit / 2]) {
    translate([0, 0, bridge_h]) cube([wall_t + x_fit, insert_w, wall_t]);
    translate([wall_t + x_fit, 0]) cube([wall_t - x_fit, insert_w, bridge_h + wall_t]);
  }
}

//
// Single compartment of given size in `u`.
//
module compartment (size, lid_hinge = false) {
  o_x = outer_x(size[0]);
  o_y = outer_y(size[1]);
  o_z = size[2] * u;

  i_x = o_x - 2 * wall_t;
  i_y = o_y - 2 * wall_t;
  i_z = o_z - 2 * wall_t; // The "second" `wall_t` is for any lids, etc. we might want to attach.

  insert_bridge_h = lid_hinge ? o_z - hinge_i_d - hinge_wall_t - 2 * wall_t : 0.7 * o_z;

  // Bottom:
  cube([o_x, o_y, wall_t]);

  // Walls:
  translate([0, 0, wall_t]) {
    difference () {
      square_sleeve([o_x, o_y, i_z], wall_t);
      // Clear out space for the lid's hinge to rotate around in.
      translate([o_x - hinge_i_d, wall_t, i_z - hinge_i_d - hinge_wall_t])
        cube([hinge_i_d, o_y - 2 * wall_t, hinge_i_d + hinge_wall_t]);
    }
  }

  translate([o_x, -2 * wall_t]) rotate([0, 0, 90]) receptacle(o_x, insert_bridge_h - fit);
  translate([wall_t, o_y]) rotate([0, 0, 180]) receptacle(o_y, insert_bridge_h - fit);

  for (j = [1 : floor(size[0])])
    translate([wall_t + total_u * (j - 1), o_y])
      rotate([0, 0, 270]) mirror([1, 0, 0])
        insert(o_z, insert_bridge_h);

  for (i = [1 : floor(size[1])])
    translate([o_x, wall_t + total_u * (i - 1)]) insert(o_z, insert_bridge_h);

  if (lid_hinge) {
    translate([o_x - hinge_o_d / 2, 0, o_z - hinge_i_d]) hinge(i_y);
  }
}

if (!is_undef(size)) {
  compartment(size, true);
}
