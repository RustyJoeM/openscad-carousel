include <carousel-config.scad>;
include <wall-commons.scad>;

_COLUMN_DIAM = BEAM_SIZE + 2 * STRUT_OVERRUN;

module carousel_wall_column(diam_bleed = 0, ground_bleed = 0, height = COLUMN_HEIGHT) {
    color(COLOR_STRUTS)
    rotate([-90, 0, 0])
    translate([0, 0, -ground_bleed])
        cylinder(h = height + ground_bleed, d = _COLUMN_DIAM + diam_bleed);
}

module columns_side_holes() {
    translate([-FX, 0, 0])
        carousel_wall_column(diam_bleed = EASE, ground_bleed = BLEED, height = 2 * COLUMN_HEIGHT);
    translate([FX, 0, 0])
        carousel_wall_column(diam_bleed = EASE, ground_bleed = BLEED, height = 2 * COLUMN_HEIGHT);
}

JOINT_DIMENSIONS = [0.25 * _COLUMN_DIAM, 0.75 * _COLUMN_DIAM, 0.25 * _COLUMN_DIAM];

module carousel_wall_column_half() {
    joint_y_pos = [0.05, 0.35, 0.65, 0.95];

    cutoff_width = _COLUMN_DIAM + BLEED;
    cutoff_length = COLUMN_HEIGHT + BLEED;
    cuttof_height = _COLUMN_DIAM/2 + BLEED;

    color(COLOR_STRUTS)
    difference() {
        carousel_wall_column();
        // remove bottom half of column
        translate([0,  cutoff_length/2 - BLEED/2, -cuttof_height/2])
            cube([cutoff_width, cutoff_length, cuttof_height], center = true);
        // and make holes for inter-connecting pegs
        for (fy = joint_y_pos) {
            translate([0, fy * COLUMN_HEIGHT, JOINT_DIMENSIONS.z/2 - BLEED])
                cube([JOINT_DIMENSIONS.x + EASE, JOINT_DIMENSIONS.y + EASE, JOINT_DIMENSIONS.z + EASE], center = true);
        }
    }
}

module carousel_wall_column_peg() {
    x = 2 * JOINT_DIMENSIONS.z;
    y = JOINT_DIMENSIONS.y;
    z = JOINT_DIMENSIONS.x;

    color(COLOR_STRUTS)
    translate([0, 0, z/2])
    cube([x, y, z], center = true);
}

carousel_wall_column_half();
