press_fit = 0.05;
tight_fit = 0.1;
fit = 0.2;
loose_fit = 0.5;

// `u` - a single unit of size within our containers. Containers with the
// same `u` and `wall_t` can compose with each other.
u = 20;

// Wall thickness.
wall_t = 1.2; // Minimum thickness that makes sense with 0.4 mm FDM.

total_u = u + 2 * wall_t;

hinge_u = 1.6; // Minimum "unit" that produces a sensible hinge with 0.4 mm FDM.
hinge_o_d = hinge_u * 4;
hinge_i_d = hinge_u * 2;
hinge_wall_t = (hinge_o_d - hinge_i_d) / 2;

// Hinge supports:
hinge_support_step = 20; // How often to place a support for the hinge. 
hinge_support_w = 3.2;
hinge_support_t = hinge_u;
hinge_rib_t = loose_fit;

lid_hinge_angle = 260;

emboss_versions = false;
version_emboss_depth = wall_t / 3;
version_emboss_font_size = 2;
version_emboss_offset = 3 * wall_t;
