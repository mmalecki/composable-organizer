use <utils.scad>;
include <parameters.scad>;

$fn = 50;
module receptacle (h) {
  square_sleeve([receptacle_d, u, h], wall_t);
}

module hinge (i_y) {
  // Hinge bridge:
  translate([wall_t / 2, wall_t, 0])
    rotate([270, 0, 0]) cylinder(d = hinge_i_d, h = i_y);
}

module insert (o_z, bridge_h) {
  x_fit = loose_fit;
  y_fit = loose_fit;
  insert_w = u - 2 * wall_t - y_fit;

  translate([0, y_fit / 2]) {
    translate([0, 0, bridge_h]) cube([wall_t + x_fit / 2, insert_w, wall_t]);
    translate([wall_t + x_fit / 2, 0]) cube([wall_t - x_fit, insert_w, o_z - wall_t]);
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
      translate([o_x - hinge_i_d, wall_t, i_z - hinge_i_d - hinge_wall_t])
        cube([hinge_i_d, o_y - 2 * wall_t, hinge_i_d + hinge_wall_t]);
    }
  }

  translate([o_x, -2 * wall_t]) rotate([0, 0, 90]) receptacle(insert_bridge_h);
  translate([wall_t, o_y]) rotate([0, 0, 180]) receptacle(insert_bridge_h);

  translate([o_x, wall_t]) insert(o_z, insert_bridge_h);
  translate([o_x - wall_t, o_y]) rotate([0, 0, 90]) insert(o_z, insert_bridge_h);

  if (lid_hinge) {
    translate([o_x - hinge_o_d / 2 - wall_t / 2, 0, o_z - hinge_i_d]) hinge(i_y);
  }
}

module lid (size) {
  w = u * size[1];
  w_fit = w - fit;

  translate([0, 0, hinge_u - wall_t]) {
    hull () {
      cube([w - hinge_o_d, w, wall_t]);
      translate([w - hinge_o_d, (w - w_fit) / 2])
        cube([hinge_o_d * 1/2, w_fit, wall_t]);
    }
  }

  translate([w - hinge_o_d / 2, (w - w_fit) / 2, -hinge_o_d / 4]) {
    rotate([270, (360 - lid_hinge_angle) / 2 + 90, 0])
      circle_sleeve(hinge_o_d, w_fit, hinge_wall_t - press_fit, lid_hinge_angle);
  }
}

size = [2, 2, 2];
compartment(size, lid_hinge = true);
// translate([0, 0, size[2] * u - hinge_i_d / 2]) lid(size);
