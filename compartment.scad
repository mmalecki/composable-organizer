use <utils.scad>;
use <sizing.scad>;
include <parameters.scad>;

module receptacle (o_y, h) {
  receptacle_d = 3 * wall_t;
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

module hinge (i_y, o_z) {
  // Hinge bridge:
  translate([0, wall_t, o_z - hinge_i_d]) {
    rotate([270, 0, 0]) cylinder(d = hinge_i_d, h = i_y);
    hinge_supports(i_y);
  }

  // Ribs (in hopes of supporting the structure a little):
  translate([-hinge_i_d / 2, wall_t])
    cube([hinge_i_d, hinge_rib_t, o_z - wall_t]);
  translate([-hinge_i_d / 2, i_y + wall_t - hinge_rib_t])
    cube([hinge_i_d, hinge_rib_t, o_z - wall_t]);
}

module insert (o_z, bridge_h, lid_guard = false) {
  x_fit = loose_fit;
  y_fit = loose_fit;
  insert_w = u - 2 * wall_t - y_fit;

  translate([0, y_fit / 2]) {
    translate([0, 0, bridge_h]) cube([wall_t + x_fit, insert_w, wall_t]);
    translate([wall_t + x_fit, 0])
      cube([wall_t - x_fit, insert_w, bridge_h + wall_t + (lid_guard ? hinge_i_d : 0)]);
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
  // If the compartment has a lid hinge, add in a clearanace for that lid in
  // order to stay under `u * z` outer size.
  i_z = o_z - (lid_hinge ? 2 : 1) * wall_t;

  insert_bridge_h = o_z - hinge_i_d - hinge_wall_t - 2 * wall_t;

  // Bottom:
  cube([o_x, o_y, wall_t]);

  // Walls:
  echo(lid_hinge);
  translate([0, 0, wall_t]) {
    difference () {
      square_sleeve([o_x, o_y, i_z], wall_t);
      if (lid_hinge) {
        // Clear out space for the lid's hinge to rotate around in.
        translate([o_x - hinge_i_d, wall_t, i_z - hinge_i_d - hinge_wall_t])
          cube([hinge_i_d, o_y - 2 * wall_t, hinge_i_d + hinge_wall_t]);
      }
    }
  }

  translate([o_x, -2 * wall_t]) rotate([0, 0, 90]) receptacle(o_x, insert_bridge_h - fit);
  translate([wall_t, o_y]) rotate([0, 0, 180]) receptacle(o_y, insert_bridge_h - fit);

  for (j = [1 : floor(size[0])])
    translate([wall_t + total_u * (j - 1), o_y])
      rotate([0, 0, 270]) mirror([1, 0, 0])
        insert(o_z, insert_bridge_h);

  for (i = [1 : floor(size[1])])
    translate([o_x, wall_t + total_u * (i - 1)]) insert(o_z, insert_bridge_h, lid_guard = lid_hinge);

  if (lid_hinge) {
    to_hinge_x(o_x) hinge(i_y, o_z);
  }
}

if (!is_undef(size)) {
  compartment(size, true);
}
