include <carousel-config.scad>;

_AXLE_COLOR = "SaddleBrown";

arm_height = 2 * AXLE_RADIUS;
axle_height = ROOF_HEIGHT + BASE_TOTAL_HEIGHT - EASE;

module carousel_axle_arms() {
    arm_length = 8 * AXLE_RADIUS;
    arm_width = AXLE_RADIUS;

    color(_AXLE_COLOR) {
        difference() {
            union() {
                cylinder(h = arm_height, r = 2 * AXLE_RADIUS);
                for (i = [0 : CAROUSEL_FACE_COUNT/2]){
                    rotate(2 * i * 360/CAROUSEL_FACE_COUNT, [0, 0, 1])
                    translate([0, -arm_width/2, 0])
                    cube([arm_length, arm_width, arm_height]);
                }
            }
            translate([0, 0, -BLEED/2])
                cylinder(h = arm_height + BLEED, r = AXLE_RADIUS + EASE);
        }
    }
}

module carousel_axle() {
    color(_AXLE_COLOR) {
        cylinder(h = axle_height, r = AXLE_RADIUS);
        translate([0, 0, axle_height - 3 * arm_height])
            cylinder(h = 2 * AXLE_RADIUS, r1 = AXLE_RADIUS, r2 = 2 * AXLE_RADIUS);
    }
}

// just for presentation, for 3D print the separate parts are better...
module carousel_axle_all_in_one() {
    carousel_axle();
    translate([0, 0, axle_height - 2 * arm_height])
    carousel_axle_arms();
}

PEG_SIZE = [0.5 * AXLE_RADIUS, 0.5 * AXLE_RADIUS, 1.5 * AXLE_RADIUS];

module carousel_axle_half() {
    peg_heights = [0.05, 0.35, 0.65, 0.95];

    translate([-axle_height/2, 0, 0])
    rotate([0, 90, 0])
    difference() {
        carousel_axle();
        translate([0, -5 * AXLE_RADIUS, -BLEED/2])
            cube([10 * AXLE_RADIUS, 10 * AXLE_RADIUS, axle_height + BLEED]);
        for (fz = peg_heights) {
            translate([-PEG_SIZE.x, -PEG_SIZE.y/2, fz * axle_height])
                cube([PEG_SIZE.x + EASE, PEG_SIZE.y + EASE, PEG_SIZE.z + EASE]);
        }
    }
}

module carousel_axle_peg() {
    //translate([0, 0, PEG_SIZE.x/2])
    x = PEG_SIZE.z;
    y = PEG_SIZE.y * 2;
    z = PEG_SIZE.x;

    color(_AXLE_COLOR)
    cube([x, y, z], center = true);
}

module carousel_axle_bom() {
    dy = 3 * AXLE_RADIUS;

    translate([0, dy, 0])
    carousel_axle_half();

    translate([0, -dy, 0])
    rotate([0, 0, 180])
        carousel_axle_half();

    for (i = [0:3]) {
        translate([2 * i * PEG_SIZE.z, 0, PEG_SIZE.x/2])
        carousel_axle_peg();
    }
}

carousel_axle_bom();