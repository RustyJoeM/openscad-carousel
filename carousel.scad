// ----------------------------------------------------------------------------
// Configuration of the carousel and its components.
//
// All the values beyod "---- derived" string in each of the sections should
// not be modified manually, as they are derived from the previously defined
// parameters in some way...
// ----------------------------------------------------------------------------

// Generic parameters to address consistency & interconnections of parts.
CYL_FN = 32; // BEWARE!!! set to +- 256 for STL export!
BLEED = 0.1; // overlap for union & difference operations
EASE = 0.5; // socket/pin ease for interconnecting of parts & holes

// Core defining shape of our carousel is N-faced cylinder.
// This affects most of the subsequent parameter definitions & usage.
CAROUSEL_FACE_COUNT = 6;
CAROUSEL_ESCRIBED_RADIUS = 120;
// ---- derived
CAROUSEL_INSCRIBED_RADIUS = CAROUSEL_ESCRIBED_RADIUS * cos(180/CAROUSEL_FACE_COUNT);

// Base of the carousel -> stand that holds the axle, walls, etc.
BASE_TOTAL_HEIGHT = 24;
BASE_FLOOR_HEIGHT = 8;
// ---- derived
BASE_RADIUS = 1.05 * CAROUSEL_ESCRIBED_RADIUS; // to include/cover carousel walls

// Face, or, a wall of the carousel "shell".
FACE_HEIGHT = 150;
FACE_THICKNESS = 5;
// ---- derived
FACE_WIDTH = CAROUSEL_ESCRIBED_RADIUS * 2 * sin(180/CAROUSEL_FACE_COUNT);
FACE_ANGLE = (1 - 2/CAROUSEL_FACE_COUNT)*180;
FACE_APOTHEM_LEN = FACE_WIDTH / (2 * tan(180/CAROUSEL_FACE_COUNT));
FACE_DOOR_HEIGHT = 0.66 * FACE_HEIGHT;

// Roof of the carousel.
ROOF_THICKNESS = 2;
ROOF_HEIGHT = 1.3 * FACE_HEIGHT;

// Ball bearing - real-life dimensions of ball bearing used to "power" the axle.
BEARING_OUTER_D = 22;
BEARING_INNER_D = 8;
BEARING_HEIGHT = 7;

// Axle rotating inside carousel.
AXLE_RADIUS = 4;

// Rotating rig carrying the seats.
RIG_HEIGHT = 8;
RIG_STR = 6;

// ----------------------------------------------------------------------------

// TODO - resolve case for different thickness of axle vs bearing inner diameter!
module bearing_socket() {
    PAD_F = 0.25;
    difference() {
        // socket body
        cylinder(h = (1 + PAD_F) * BEARING_HEIGHT, d = 1.5 * BEARING_OUTER_D, $fn = CYL_FN);
        // bearing slot
        translate([0, 0, PAD_F * BEARING_HEIGHT - EASE])
        cylinder(h = 1.1 * BEARING_HEIGHT, d = BEARING_OUTER_D + EASE, $fn = CYL_FN);
        translate([0, 0, -0.05 * PAD_F * BEARING_HEIGHT])
        cylinder(h = 1.1 * PAD_F * BEARING_HEIGHT, d = BEARING_INNER_D + EASE, $fn = CYL_FN);
        // TODO - rig pass-through hole - maybe not needed?
    }
}

module carousel_base() {
    color("BurlyWood") {
        // floor plate
        translate([0, 0, -BASE_FLOOR_HEIGHT/2])
        difference() {
            cylinder(h = BASE_FLOOR_HEIGHT, r = BASE_RADIUS, center = true, $fn = CYL_FN);
            cylinder(h = 1.1 * BASE_FLOOR_HEIGHT, r = AXLE_RADIUS + EASE, center = true, $fn = CYL_FN);
        }

        // rim/side wall
        edge_height = BASE_TOTAL_HEIGHT - BASE_FLOOR_HEIGHT;
        translate([0, 0, -edge_height/2 - BASE_FLOOR_HEIGHT + BLEED])
        difference() {
            cylinder(h = edge_height, r = BASE_RADIUS, center = true, $fn = CYL_FN);
            cylinder(h = 1.1 * edge_height, r = BASE_RADIUS - BASE_FLOOR_HEIGHT, center = true, $fn = CYL_FN);
        }

        // bearing socket
        assert(BASE_FLOOR_HEIGHT + BEARING_HEIGHT < BASE_TOTAL_HEIGHT, "Bearing height is too big to fit into raised base");
        translate([0, 0, -BASE_FLOOR_HEIGHT])
        rotate([0, 180, 0])
        bearing_socket();
    }
}

module carousel_axle() {
    color("SaddleBrown")
    cylinder(h = ROOF_HEIGHT, r = AXLE_RADIUS);
}

module leaning_cube(size, a, b) {
//    echo(str("leaning cube from ", a, " to ", b));
    dir = b - a;
    h = norm(dir);
    if(dir[0] == 0 && dir[1] == 0) {
        // no transformation necessary
        translate(a)
        translate([0, 0, h/2])
        cube([size, size, h], center = true);
    }
    else {
        w  = dir / h;
        u0 = cross(w, [0,0,1]);
        u  = u0 / norm(u0);
//        echo(str("    dir = ", dir, "; h = ", h, "; w = ", w, "; u = ", u));
        v0 = cross(w, u);
        v  = v0 / norm(v0);
        multmatrix(m=[[u[0], v[0], w[0], a[0]],
                      [u[1], v[1], w[1], a[1]],
                      [u[2], v[2], w[2], a[2]],
                      [0,    0,    0,    1]])
        translate([0, 0, h/2])
        cube([size, size, h], center = true);
    }
}

module beam(size, points) {
    for (i = [0 : len(points)-2]) {
        a = points[i];
        b = points[i+1];
        leaning_cube(size, a, b);
    }
}

module point_plate(thickness, points) {
    hull() {
        for (i = [0 : len(points)-1]){
            translate(points[i])
            sphere(d = thickness);
        }
    }
}

module carousel_face() {
    // calculate points for the face border/full shape
    FX = FACE_WIDTH/2;
    FY = FACE_HEIGHT;
    FF = 0.85;
    face_xy_points = [
        [FX, -BLEED],
        [FX, FF * FY],
        [0, FY],
        [-FX, FF * FY],
        [-FX, -BLEED]
    ];

    // calculate points for the door hole
    DX = 0.75 * FACE_WIDTH/2;
    DY = FACE_DOOR_HEIGHT;
    DF1 = [1.00, 0.50];
    DF2 = [0.85, 0.75];
    DF3 = [0.45, 0.95];
    door_xy_points = [
        [DX, -2*BLEED],
        [DF1[0]*DX, DF1[1]*DY],
        [DF2[0]*DX, DF2[1]*DY],
        [DF3[0]*DX, DF3[1]*DY],
        [0, DY],
        [-DF3[0]*DX, DF3[1]*DY],
        [-DF2[0]*DX, DF2[1]*DY],
        [-DF1[0]*DX, DF1[1]*DY], 
        [-DX, -2*BLEED]
    ];

    rotate([0, 0, FACE_ANGLE/2])
    translate([0, -FACE_APOTHEM_LEN, 0])
    {
        color("Gold")
        difference() {
            // inner mass/wall
            rotate([90, 0, 0])
            linear_extrude(FACE_THICKNESS, center = true)
                polygon(face_xy_points);
            // door hole
            rotate([90, 0, 0])
            linear_extrude(2 * FACE_THICKNESS, center = true)
                polygon(door_xy_points );
        }
        // wooden reinforcements
        BEAM_SIZE = 1.1 * FACE_THICKNESS;
        color("SaddleBrown") {
            // left side column
            translate([-FX, 0, -2*BLEED])
            rotate([0, 0, -(180 - FACE_ANGLE)/2])
            translate([0, 0, FF*FY/2 + BEAM_SIZE/4])
                cube([BEAM_SIZE, BEAM_SIZE, FF * FY + BEAM_SIZE/2], center = true);
            // horizontal full widths
            beam(BEAM_SIZE, [[-FX + BLEED, 0, DY], [FX - BLEED, 0, DY]]);
            beam(BEAM_SIZE, [[-FX + BLEED, 0, (FY + DY)/2], [FX - BLEED, 0, (FY + DY)/2]]);
            // central vertical
            beam(BEAM_SIZE, [[0, 0, DY], [0, 0, FY]]);
            // side verticals
            beam(BEAM_SIZE, [[DX - BLEED, 0, -2 * BLEED], [DX, 0, (FY + DY)/2 - BLEED]]);
            beam(BEAM_SIZE, [[-DX + BLEED, 0, -2 * BLEED], [-DX, 0, (FY + DY)/2 - BLEED]]);
//            // roof
            beam(BEAM_SIZE, [[-FX + BLEED, 0, FF * FY], [-BLEED, 0, FY]]);
            beam(BEAM_SIZE, [[+FX - BLEED, 0, FF * FY], [+BLEED, 0, FY]]);
//            // horizontal short sides
            beam(BEAM_SIZE, [[-FX + BLEED, 0, DF1[1]*DY], [-DX + BLEED, 0, DF1[1]*DY]]);
            beam(BEAM_SIZE, [[+FX - BLEED, 0, DF1[1]*DY], [+DX - BLEED, 0, DF1[1]*DY]]);
            // arched shorts
            for (i = [1 : len(door_xy_points)-3]){
                a = [door_xy_points[i][0], 0, door_xy_points[i][1]];
                b = [door_xy_points[i+1][0], 0, door_xy_points[i+1][1]];
                beam(BEAM_SIZE, [a, b]);
            }
        }
        // roof part
        OH = 0.1 * FACE_APOTHEM_LEN;
        RHR = 0.8 * FACE_APOTHEM_LEN;
        rpts = [
            [-FX, -OH, FF*FY],  // 0
            [  0, -OH,    FY],  // 1
            [+FX, -OH, FF*FY],  // 2
            [+FX, 0, FF*FY],    // 3
            [  0, +0.25*FACE_APOTHEM_LEN, FY],    // 4
            [-FX, 0, FF*FY],    // 5
            [+0.2*FX, RHR, ROOF_HEIGHT],    // 6
            [      0, RHR, ROOF_HEIGHT],    // 7
            [-0.2*FX, RHR, ROOF_HEIGHT],    // 8
        ];
        color("PaleGreen")
        translate([0, 0, BEAM_SIZE/2])
        {
            point_plate(ROOF_THICKNESS, [rpts[0], rpts[1], rpts[4], rpts[5]]);
            point_plate(ROOF_THICKNESS, [rpts[1], rpts[2], rpts[3], rpts[4]]);
            point_plate(ROOF_THICKNESS, [rpts[3], rpts[4], rpts[6]]);
            point_plate(ROOF_THICKNESS, [rpts[4], rpts[5], rpts[8]]);
            point_plate(ROOF_THICKNESS, [rpts[4], rpts[8], rpts[6]]);
            translate([0, 0, ROOF_THICKNESS]) {
                beam(ROOF_THICKNESS, [rpts[1], rpts[4]]);
                beam(ROOF_THICKNESS, [rpts[5], rpts[8]]);
            }
        }
    }
}

module carousel_faces() {
    for (i = [0 : CAROUSEL_FACE_COUNT]){
        rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1])
        carousel_face();
    }
}

module carousel_rig() {
    ring_positions = [0.3, 0.6, 0.9];
    inner_sin = sin(360/CAROUSEL_FACE_COUNT/2);

    max_r = 0.90 * CAROUSEL_INSCRIBED_RADIUS;

    color("SaddleBrown")
    translate([0, 0, 1.05 * FACE_DOOR_HEIGHT]) {
        // core ring
        difference() {
            cylinder(h = RIG_HEIGHT, r = 0.1 * max_r, center = true);
            cylinder(h = 1.1*RIG_HEIGHT, r = AXLE_RADIUS + EASE, center = true);
        }
        
        // outer ring
        difference() {
            cylinder(h = RIG_HEIGHT, r = max_r, center = true);
            cylinder(h = 1.1*RIG_HEIGHT, r = 0.95 * max_r, center = true);
        }

        // iterate each face/wall spot
        for (i = [0 : CAROUSEL_FACE_COUNT]){
            rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1]) {
                // star-beam
                beam(RIG_STR, [[0.05 * max_r, 0, 0], [max_r, 0, 0]]);
                // iterate nested "rings"
                for (frac = ring_positions) {
                    ring_r = frac * max_r;
                    translate([ring_r, 0, 0])
                    rotate([0, 0, 180 - FACE_ANGLE/2])
                    beam(RIG_STR, [[0, 0, 0], [2 * ring_r * inner_sin, 0, 0]]);
                }
            }
        }
    
    }
}

ring_positions = [0.3, 0.6, 0.9];
max_r = 0.90 * CAROUSEL_INSCRIBED_RADIUS;

// helper to hint a position of odd/even seats placed on the base floor
module seat_markers() {
    for (i = [0 : CAROUSEL_FACE_COUNT]){
        color("red")
        rotate(i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1]) {
            beam(1, [[0.05 * max_r, 0, 0], [max_r, 0, 0]]);
            for (j = [0 : len(ring_positions)-1]) {
                if ((i + j) % 2) {
                    translate([ring_positions[j] * max_r, 0, 0])
                    rotate([0, 0, 180 - FACE_ANGLE/2])
                    sphere(r = AXLE_RADIUS);
                }
            }
        }
    }
    spot_cnt = CAROUSEL_FACE_COUNT/2 * len(ring_positions);
    echo(str("--- Total number of seat spots: ", spot_cnt));
}

// TODO
module carouseled() {
    color("red")
    cylinder(h = 1.05 * FACE_DOOR_HEIGHT, r = AXLE_RADIUS/3);

    translate([0, 0, ring_positions[0] * max_r])
    intersection() {
//        cylinder(h = , r = );
        children();
    }
}

// ----------------------------------------------------------------------------

carousel_base();
carousel_axle();
carousel_faces();
