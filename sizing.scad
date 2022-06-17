include <parameters.scad>;

function outer_x (x) = x * u + (x - 1) * (2 * wall_t);
function outer_y (y) = y * u + (y - 1) * (2 * wall_t);
function outer_z (z) = z * u;

function insert_bridge_h (o_z) = o_z - hinge_i_d - hinge_wall_t - 2 * wall_t;
