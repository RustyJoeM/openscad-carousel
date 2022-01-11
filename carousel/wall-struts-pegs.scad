include <config.scad>;
include <wall-commons.scad>;

// positions of the pegs connecting the wooden struts and wall core
PEG_X = FACE_DOOR_WIDTH/2 - BEAM_SIZE/2;

PEG_Y1 = FACE_DOOR_HEIGHT - BEAM_SIZE/2;
PEG_Y2 = (FY + FACE_DOOR_HEIGHT)/2;
PEG_Y3 = FACE_DOOR_HEIGHT - FACE_DOOR_WIDTH/2;

function peg_points() = [
    [0, FY - 0.75 * BEAM_SIZE],
    [0, PEG_Y1 + 1.5 * BEAM_SIZE],
    [+PEG_X, PEG_Y1],
    [-PEG_X, PEG_Y1],
    [+PEG_X, PEG_Y2],
    // [  0, PEG_Y2],
    [-PEG_X, PEG_Y2],
    [+PEG_X + 1.25 * BEAM_SIZE, PEG_Y3],
    [-PEG_X - 1.25 * BEAM_SIZE, PEG_Y3],
];

module strut_peg(height, diam_ease = 0) {
    PEG_DIAMETER = 0.66 * BEAM_SIZE;
    cylinder(h = height, d = PEG_DIAMETER + diam_ease);
}

strut_peg(FACE_THICKNESS/2);
