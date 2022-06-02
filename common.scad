use <utils.scad>;
include <parameters.scad>;

module receptacle (o_y, h) {
  receptacle_d = 3 * wall_t;
  square_sleeve([receptacle_d, o_y, h], wall_t);
}

