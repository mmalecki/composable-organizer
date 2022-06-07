use <utils.scad>;
use <sizing.scad>;
include <parameters.scad>;

module lid (size) {
  // This is so when `hinge_support_step = u`, we get an aesthetically pleasing
  // effect with the insert. There, I'm that vain.
  receptacle_fit = 2 * fit + hinge_rib_t;

  o_x = outer_x(size[0]);
  o_y = outer_y(size[1]);
  w = o_y - 2 * wall_t;

  w_fit = w - 2 * receptacle_fit;
  body_l = o_x - hinge_o_d;

  receptacles = floor(o_y / hinge_support_step);
  receptacle_w = hinge_support_step - 2 * receptacle_fit - 2 * wall_t;
  translate([0, wall_t, -hinge_o_d / 4 + fit / 2]) {
    for (i = [1 : 1 : receptacles]) {
      translate([
        0,
        receptacle_fit + (hinge_support_step + 2 * wall_t) * (i - 1),
        0
      ]) {
        rotate([270, (360 - lid_hinge_angle) / 2 + 90, 0]) {
          circle_sleeve(
            hinge_o_d - fit,
            receptacle_w,
            // The `tight_fit` is the fit around the hinge, `fit / 2` comes
            // from the `- fit` on the outer diatemeter.
            hinge_wall_t - tight_fit - fit / 2,
            lid_hinge_angle
          );
        }
      }
    }
  }

  translate([0, 0, hinge_u - wall_t]) {
    difference () {
      hull () {
        translate([0, wall_t + (w - w_fit) / 2])
          cube([hinge_o_d / 2, w_fit, wall_t]);

        translate([hinge_o_d / 2, 0, 0]) {
          cube([body_l, outer_y(size[1]), wall_t]);
        }
      }

      if (emboss_versions) {
        translate([hinge_o_d / 2 + version_emboss_offset, version_emboss_offset, 0]) {
          rotate([0, 0, 270]) linear_extrude (version_emboss_depth) {
            mirror([1, 0, 0]) text(
              str(
                is_undef(git_tag) ? "" : str(git_tag, "-"),
                is_undef(git_sha) ? "(unknown)" : git_sha
              ),
              size = version_emboss_font_size
            );
          }
        }
      }
    }
  }
}

if (!is_undef(size)) {
  rotate([180, 0, 0]) lid(size);
}
