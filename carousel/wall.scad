include <config.scad>;
use <commons.scad>;

include <wall-commons.scad>;
use <wall-core.scad>;
use <wall-column.scad>;
use <wall-struts.scad>;
use <wall-roof.scad>;

module mounted_wall() {
    rotate([90, 0, 0]) {
        wall_core_trimmed();
        printable_door_strut(z_centered = true);

        // for mounting struts on core
        STRUT_DZ = FACE_THICKNESS/2 + STRUT_OVERRUN + EASE;

        translate([0, 0, -STRUT_DZ])
        printable_wall_struts_inner();

        translate([0, 0, STRUT_DZ])
        rotate([0, 180, 0])
        printable_wall_struts_outer();
    }

    carousel_roof_mounted();
}

module mounted_walls() {
    for (i = [0 : CAROUSEL_FACE_COUNT]) {
        rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1])
        translate([0, -FACE_APOTHEM_LEN, 0]) {
            mounted_wall();
            translate([-FACE_WIDTH/2, 0, 0])
            mounted_column();
        }
    }
}

// mounted_walls();
// mounted_wall();

// BEWARE! Parts to be printed not directly here, but in sub-modules...
