include <carousel-config.scad>;

FX = FACE_WIDTH/2;
FY = FACE_HEIGHT;
FF = 0.85;

BEAM_SIZE = 1.1 * FACE_THICKNESS;

STRUT_OVERRUN = 0.25 * FACE_THICKNESS;

STRUTS_COLOR = "SaddleBrown";

// for mounting struts on core
STRUT_DZ = FACE_THICKNESS/2 + STRUT_OVERRUN + EASE;

module door_shape(width, height, thickness, ground_bleed = 0) {
    radius = width/2;
    straight_height = height - radius;

    translate([0, straight_height, 0])
        cylinder(h = thickness, r = radius, center = true);
    translate([0, (straight_height - ground_bleed)/2, 0])
        cube([width, straight_height + ground_bleed, thickness], center = true);
}
