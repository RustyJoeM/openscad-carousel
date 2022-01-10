include <carousel-config.scad>;
include <wall-commons.scad>;
use <wall-column.scad>;
use <wall-struts-pegs.scad>;
use <wall-roof.scad>;

module carousel_wall_core_shape() {
    _face_xy_points = [
        [FX, 0],
        [FX, FY * FF],
        [0, FY],
        [-FX, FY * FF],
        [-FX, 0]
    ];
    linear_extrude(FACE_THICKNESS, center = true)
    polygon(_face_xy_points);
}

module carousel_wall_core() {
    color(COLOR_WALL)
    difference() {
        // main mass/wall
        carousel_wall_core_shape();
        // door hole
        door_shape(width = FACE_DOOR_WIDTH, height = FACE_DOOR_HEIGHT, thickness = (FACE_THICKNESS + BLEED), ground_bleed = 2 * BLEED);
        // strut joint holes
        for (p = peg_points()) {
            translate([p.x, p.y, -FACE_THICKNESS/2 - 0.5*BLEED])
            strut_peg(FACE_THICKNESS + BLEED, diam_ease = EASE);
        }
        // side columns
        columns_side_holes();
        // roof connectors
        translate([0, FY * FF, 0]) {
            translate([+FX/2, 0, 0])
            rotate([-90, 180, 0])
            roof_connector_joint(is_hole_mode = true);

            translate([-FX/2, 0, 0])
            rotate([-90, 0, 0])
            roof_connector_joint(is_hole_mode = true);
        }
    }
}

carousel_wall_core();
