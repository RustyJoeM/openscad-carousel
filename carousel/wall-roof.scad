include <carousel-config.scad>;
include <wall-commons.scad>;

use <commons.scad>;

canopy_height = (1-FF)*FY;

roof_canopy_overhang = 0.75 * canopy_height;

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

alpha = atan((max_z - canopy_height) / ey);

module roof_connector_joint(is_hole_mode = false) {

    max_z = ROOF_HEIGHT/2;

    width = FX/5 + (is_hole_mode ? EASE : 0);
    thickness = 0.5 * FACE_THICKNESS + (is_hole_mode ? EASE : 0);

    h1 = (FX/2-width/2)/FX * max_z;
    h2 = (FX/2+width/2)/FX * max_z;

    points = [[-width/2, 0], [+width/2, 0], [+width/2, h2], [-width/2, h1]];

    bleed_z_fix = is_hole_mode ? BLEED : 0;

    translate([0, 0, bleed_z_fix])
    rotate([90, 0, 0])
    linear_extrude(thickness, center = true)
    polygon(points);
}

module roof_shape() {

    key_points = [
        [-max_x, 0, 0], // A
        [-tx, max_y, max_z], // B
        [+tx, max_y, max_z], // C
        [+max_x, 0, 0], // D
        [0, max_y-ey, canopy_height], // E
        [0, 0, canopy_height], // F
        [-max_x, -roof_canopy_overhang, 0],
        [0, -roof_canopy_overhang, canopy_height],
        [+max_x, -roof_canopy_overhang, 0]
    ];

    edge_width = 1.0 * ROOF_THICKNESS;

    color(COLOR_ROOF) {
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
        // left overhang
        point_plate(ROOF_THICKNESS, key_points, [0, 4, 7, 6]);
        // right overhang
        point_plate(ROOF_THICKNESS, key_points, [4, 3, 8, 7]);
        // canopy blade
        translate([0, 0, 0.5 * ROOF_THICKNESS])
        rect_prism(edge_width, 1.5 * ROOF_THICKNESS, key_points[4], key_points[7]);

        // TODO - cut off and make stadanlone connector
        translate([0, 0, 1.0 * ROOF_THICKNESS])
        rect_prism(edge_width, 1.5 * ROOF_THICKNESS, key_points[0], key_points[1]);

        // roof to wall connectors
        translate([+FX/2, 0, 0])
        rotate([0, 0, 180])
        roof_connector_joint();

        translate([-FX/2, 0, 0])
        roof_connector_joint();
    }

}

module trimmed_roof() {
    // trim off parts that would overlap when joining multiple segments
    // on final carousel
    translate([0, FACE_APOTHEM_LEN, 0])
    difference() {
        translate([0, -FACE_APOTHEM_LEN, 0])
        roof_shape();

        rotate([0, 0, -360/CAROUSEL_FACE_COUNT])
        translate([0, -FACE_APOTHEM_LEN, 0])
        roof_shape();
    }
}

module carousel_roof_segment() {
    translate([0, 0, 0.5 * ROOF_THICKNESS])
    rotate([-alpha, 0, 0])
    trimmed_roof();
}

module carousel_roof_mounted() {
    translate([0, 0, FF*FY + 0.5 * ROOF_THICKNESS])
    trimmed_roof();
}

// carousel_roof_mounted();
// roof_connector_joint();
carousel_roof_segment();
