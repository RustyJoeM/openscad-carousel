include <carousel-config.scad>;
include <wall-commons.scad>;
use <carousel-commons.scad>;

canopy_height = (1-FF)*FY;

roof_canopy_overhang = canopy_height;

module carousel_roof() {
    // TOP-VIEW for key_points
    //
    //       tx
    //      |---|
    //      |   |
    //      |
    //      |   5           -      -
    //      |  /a\          |      |
    //        / | \ ihr     | ty   |
    //       /b | b\        |      |
    //      1---+---2       -      | FAL
    //     /    |    \             |
    //    /    _4_    \            |
    //   /b /-/   \-\ b\           |
    //  0--/         \--3          -
    inner_hole_radius = 0.25 * CAROUSEL_ESCRIBED_RADIUS;
    top_alpha = 360/CAROUSEL_FACE_COUNT;
    top_beta = 90 - top_alpha/2;
    // (ihr / CAROUSEL_INSCIRBED_RADIUS) == (ty / FACE_APOTHEM_LEN)
    ty = FACE_APOTHEM_LEN * inner_hole_radius / CAROUSEL_ESCRIBED_RADIUS;
    tx = cos(top_beta) * inner_hole_radius;

    max_x = FX;
    max_y = FACE_APOTHEM_LEN - ty;
    max_z = ROOF_HEIGHT;

    //(max_z / max_y) == ((max_z - canopy_height) / ey)
    ey = max_y * (max_z - canopy_height) / max_z;

    key_points = [
        [-max_x, 0, 0], // A
        [-tx, max_y, max_z], // B
        [+tx, max_y, max_z], // C
        [+max_x, 0, 0], // D
        [0, max_y-ey, canopy_height], // E
        [0, 0, canopy_height] // F
    ];

    color("PaleGreen") {
        // main left
        point_plate(ROOF_THICKNESS, key_points, [0, 1, 4]);
        // main right
        point_plate(ROOF_THICKNESS, key_points, [2, 3, 4]);
        // main center
        point_plate(ROOF_THICKNESS, key_points, [1, 2, 4]);
        // left canopy
        point_plate(ROOF_THICKNESS, key_points, [0, 4, 5]);
        // right canopy
        point_plate(ROOF_THICKNESS, key_points, [3, 5, 4]);
    }
}

module carousel_roof_mounted() {
    translate([0, 0, FF*FY])
    carousel_roof();
}

carousel_roof_mounted();
