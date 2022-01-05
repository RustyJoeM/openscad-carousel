include <carousel-config.scad>;
include <wall-commons.scad>;
use <wall-column.scad>;
use <wall-struts-pegs.scad>;

module carousel_wall_core() {
    _face_xy_points = [
        [FX, 0],
        [FX, FY * FF],
        [0, FY],
        [-FX, FY * FF],
        [-FX, 0]
    ];

    color("Gold")
    difference() {
        // inner mass/wall
        linear_extrude(FACE_THICKNESS, center = true)
        polygon(_face_xy_points);
        // door hole
        door_shape(width = FACE_DOOR_WIDTH, height = FACE_DOOR_HEIGHT, thickness = (FACE_THICKNESS + BLEED), ground_bleed = 2 * BLEED);
        // strut joint holes
        for (p = peg_points()) {
            translate([p.x, p.y, -FACE_THICKNESS/2 - 0.5*BLEED])
            strut_peg(FACE_THICKNESS + BLEED); // TODO center
        }
        // side columns
        columns_side_holes();
    }
}

carousel_wall_core();
