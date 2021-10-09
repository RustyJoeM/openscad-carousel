include <carousel-config.scad>;
use <carousel-commons.scad>;


// Auxiliary module to position child nodes into specific carousel seat slot.
//     ring_index - which ring of seats to mount to, innermost (0) to outermost
//     position_index - position/face index on the specified ring
module carousel_slotted(ring_index, position_index) {
    assert(ring_index < len(RIG_RING_POSITIONS), "Ring index too big!");
    assert(position_index < CAROUSEL_FACE_COUNT, "Ring position too big!");

    rotate(360/CAROUSEL_FACE_COUNT * position_index, [0, 0, 1])
    translate([RIG_RING_POSITIONS[ring_index] * RIG_MAX_R, 0, 0]) {
        cylinder(h = 1.05 * FACE_DOOR_HEIGHT, r = AXLE_RADIUS/3);
        // TODO - resolve scaling
        intersection() {
            translate([0, 0, -EASE])
            cylinder(h = FACE_DOOR_HEIGHT + 2 * EASE, r = CAROUSEL_INSCRIBED_RADIUS/len(RIG_RING_POSITIONS) + EASE);
            children();
        }
    }
}

// Helper to place a child nodes into odd/even spots around carousel.
module carousel_scattered() {
    for (i = [0 : len(RIG_RING_POSITIONS)-1]) {
        for (j = [0 : CAROUSEL_FACE_COUNT-1]) {
            if ((i + j) % 2) {
                carousel_slotted(i, j)
                children();
            }
        }
    }
    spot_cnt = CAROUSEL_FACE_COUNT/2 * len(RIG_RING_POSITIONS);
    echo(str("--- Total number of seat spots: ", spot_cnt));
}

// ----------------------------------------------------------------------------

module carousel_mounted() {
    *rotate([0, 180, 0]) carousel_base();
    *carousel_axle();
    carousel_faces();
    *translate([0, 0, 1.2 * FACE_DOOR_HEIGHT]) carousel_rig();
}

// all-in-one model, possibly not easylie printable as a whole
carousel_mounted();

// or standalone part(s) positioned on base plane for easier printing
// carousel_base();
// carousel_rig();
