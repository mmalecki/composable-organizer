use <sizing.scad>;
use <utils.scad>;
include <parameters.scad>;

module insert (o_z, bridge_h) {
  insert_w = u - 2 * wall_t - tray_insert_y_fit;

  translate([0, tray_insert_y_fit / 2])
    cube([wall_t - tray_insert_x_fit, insert_w, bridge_h + wall_t]);
}

module tray (size, walls = false) {
  o_x = outer_x(size[0]) + 6 * wall_t + 2 * tray_fit;
  o_y = outer_y(size[1]) + 6 * wall_t + 2 * tray_fit;
  o_z = outer_z(size[2]);

  bridge_h = insert_bridge_h(outer_z(size[2]));
  cube([o_x, o_y, tray_wall_t]);

  if (walls) {
    translate([-wall_t, -wall_t]) {
      square_sleeve([
        o_x + 2 * wall_t,
        o_y + 2 * wall_t,
        o_z + tray_wall_t + tray_top_fit
      ], tray_wall_t);
    }
  }

  translate([0, 0, tray_wall_t]) {
    // Inserts:
    for (i = [1 : floor(size[1])]) {
      translate([
        wall_t + tray_fit + tray_insert_x_fit / 2,
        tray_fit + 3 * wall_t + (total_u + tray_containers_fit) * (i - 1)
      ]) {
          insert(o_z, bridge_h);
      }
    }

    for (j = [1 : floor(size[0])]) {
      translate([
        tray_fit + 3 * wall_t + (total_u + tray_containers_fit) * (j - 1),
        tray_fit + 2 * wall_t - tray_insert_x_fit / 2,
      ]) {
        rotate([0, 0, 270])
          insert(o_z, bridge_h);
      }
    }
  }
}

if (!is_undef(size)) {
  tray(size, walls = true);
}
