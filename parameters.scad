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

// Inserts:
insert_x_fit = loose_fit;
insert_y_fit = loose_fit;
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
version_emboss_font_size = 3;
version_emboss_offset = wall_t;

// Tray:
//
// You may want more solid walls on your trays. The tray will still interface
// with `wall_t` compartments.
tray_wall_t = wall_t;
tray_lid_fit = press_fit;

// The fit here is larger because the tray is not the primary thing holding
// the containers together. Additionally, there's less clearance to take these
// fits apart, so we want to make that easier.
tray_insert_x_fit = loose_fit;
tray_insert_y_fit = 3;
// The fit between outside of the tray and compartments.
tray_fit = loose_fit;
tray_top_fit = tray_wall_t;
// The fit between compartments inside the tray.
tray_containers_fit = fit;

// Tray lid:
notch_h = tray_wall_t / 2;
notch_d = tray_wall_t;
notch_w = u / 2;
tray_lid_catch = 2.5 * tray_wall_t;
