include <carousel-config.scad>;
use <carousel-commons.scad>;

include <wall-commons.scad>;
use <wall-core.scad>;
use <wall-column.scad>;
use <wall-struts.scad>;
use <wall-roof.scad>;

module carousel_wall_mounted() {
    rotate([90, 0, 0]) {
        carousel_wall_core();
        carousel_door_strut();

        translate([0, 0, -STRUT_DZ])
        carousel_wall_struts();

        translate([0, 0, STRUT_DZ])
        rotate([0, 180, 0])
        carousel_wall_struts();
    }

    carousel_roof_mounted();
}

module carousel_faces_mounted() {
    for (i = [0 : CAROUSEL_FACE_COUNT]){
        rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1])
        translate([0, -FACE_APOTHEM_LEN, 0]) {
            carousel_wall_mounted();
            rotate([90, 0, 0]) {
                translate([-FACE_WIDTH/2, 0, 0])
                carousel_wall_column();
            }
        }
    }
}

// carousel_wall_mounted();
carousel_faces_mounted();