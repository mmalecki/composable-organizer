use <utils.scad>;
include <parameters.scad>;

$fn = 50;
module receptacle (h) {
  square_sleeve([receptacle_d, u, h], wall_t);
}

// Old hinge base:
// module hinge_base () {
//   hull () {
//     cube([wall_t, wall_t, hinge_base_h]);
//     translate([wall_t / 2, wall_t, hinge_h - hinge_o_d / 2])
//       rotate([90, 0, 0]) cylinder(d = hinge_o_d, h = wall_t);
//   }
// }

module hinge () {
  // Hinge bridge:
  translate([wall_t / 2, wall_t, 0])
    rotate([270, 0, 0]) cylinder(d = hinge_i_d, h = hinge_w);
}

module insert (h) {
  x_fit = loose_fit;
  y_fit = loose_fit;
  insert_w = u - 2 * wall_t - y_fit;

  translate([0, y_fit / 2]) {
    translate([0, 0, h]) cube([wall_t + x_fit / 2, insert_w, wall_t]);
    translate([wall_t + x_fit / 2, 0]) cube([wall_t - x_fit, insert_w, u - wall_t]);
  }
}

//
// Single compartment of given size in `u`.
//
module compartment (size, lid_hinge = false) {
  o_x = size[0] * u;
  o_y = size[1] * u;
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
      translate([u - hinge_i_d, wall_t, i_z - hinge_i_d - hinge_wall_t])
        cube([hinge_i_d, o_y - 2 * wall_t, hinge_i_d + hinge_wall_t]);
    }
  }

  translate([o_x, -2 * wall_t]) rotate([0, 0, 90]) receptacle(insert_bridge_h);
  translate([wall_t, o_y]) rotate([0, 0, 180]) receptacle(insert_bridge_h);

  translate([o_x, wall_t]) insert(insert_bridge_h);
  translate([o_x - wall_t, o_y]) rotate([0, 0, 90]) insert(insert_bridge_h);

  if (lid_hinge) {
    translate([u - hinge_o_d / 2 - wall_t / 2, 0, o_z - hinge_i_d]) hinge();
  }
}

module lid () {
  w = hinge_w - fit;

  translate([0, 0, hinge_u - wall_t]) {
    hull () {
      cube([u - hinge_o_d, u, wall_t]);
      translate([u - hinge_o_d, (u - w) / 2])
        cube([hinge_o_d * 1/2, w, wall_t]);
    }
  }

  translate([u - hinge_o_d / 2, (u - w) / 2, -hinge_o_d / 4]) {
    rotate([270, (360 - lid_hinge_angle) / 2 + 90, 0])
      circle_sleeve(hinge_o_d, w, hinge_wall_t - press_fit, lid_hinge_angle);
  }
}

compartment([1, 1, 1], lid_hinge = true);
translate([0, 0, u - hinge_i_d / 2]) lid();
