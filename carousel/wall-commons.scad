include <config.scad>;
use <commons.scad>;

FX = FACE_WIDTH/2;
FY = FACE_HEIGHT;
FF = FACE_HEIGHT_ROOF_START_RATIO;

COLUMN_HEIGHT = FF * FY - 0.0 * BEAM_SIZE;

STRUT_OVERRUN = 0.2 * FACE_THICKNESS;

module door_shape(width = FACE_DOOR_WIDTH, height = FACE_DOOR_HEIGHT, thickness = FACE_THICKNESS + 2 * STRUT_OVERRUN, ground_bleed = 0) {
    radius = width/2;
    straight_height = height - radius;

    difference() {
        translate([0, straight_height, 0])
        cylinder(h = thickness, r = radius, center = true);
        translate([-(width + BLEED)/2, straight_height - 2 * height - BLEED, -(thickness + BLEED)/2])
        cube([width + BLEED, 2 * height, thickness + BLEED], center = false);
    }
    translate([0, (straight_height - ground_bleed)/2, 0])
    cube([width, straight_height + ground_bleed, thickness], center = true);
}
