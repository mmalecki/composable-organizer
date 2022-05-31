include <parameters.scad>;

function outer_x (x) = x * u + (x - 1) * (2 * wall_t);
function outer_y (y) = y * u + (y - 1) * (2 * wall_t);
