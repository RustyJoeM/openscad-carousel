// ----------------------------------------------------------------------------
// Configuration of the carousel and its components.
//
// All the values beyod "---- derived" string in each of the sections should
// not be modified manually, as they are derived from the previously defined
// parameters in some way...
// ----------------------------------------------------------------------------

// Generic parameters to address consistency & interconnections of parts.
CYL_FN = 32; // BEWARE!!! set to +- 256 for STL export!
BLEED = 0.5; // overlap for union & difference operations
EASE = 0.2; // socket/pin ease for interconnecting of parts & holes

// Core defining shape of our carousel is N-faced cylinder.
// This affects most of the subsequent parameter definitions & usage.
CAROUSEL_FACE_COUNT = 6;
CAROUSEL_ESCRIBED_RADIUS = 120;
// ---- derived
CAROUSEL_INSCRIBED_RADIUS = CAROUSEL_ESCRIBED_RADIUS * cos(180/CAROUSEL_FACE_COUNT);

// Base of the carousel -> stand that holds the axle, walls, etc.
BASE_TOTAL_HEIGHT = 24;
BASE_FLOOR_THICKNESS = 4;
BASE_WALL_THICKNESS = 4;

// Face, or, a wall of the carousel "shell".
FACE_HEIGHT = 150;
FACE_THICKNESS = 5;
// ---- derived
FACE_WIDTH = CAROUSEL_ESCRIBED_RADIUS * 2 * sin(180/CAROUSEL_FACE_COUNT);
FACE_ANGLE = (1 - 2/CAROUSEL_FACE_COUNT)*180;
FACE_APOTHEM_LEN = FACE_WIDTH / (2 * tan(180/CAROUSEL_FACE_COUNT));
FACE_DOOR_HEIGHT = 0.66 * FACE_HEIGHT;
FACE_DOOR_WIDTH = 0.75 * FACE_WIDTH;

// Roof of the carousel.
ROOF_THICKNESS = 2;
ROOF_HEIGHT = 0.3 * FACE_HEIGHT;

// Ball bearing - real-life dimensions of ball bearing used to "power" the axle.
BEARING_OUTER_D = 22;
BEARING_INNER_D = 8;
BEARING_HEIGHT = 7;
BEARING_SHELL_THICKNESS = 2;

// Axle rotating inside carousel.
AXLE_RADIUS = 4;

// Rotating rig carrying the seats.
RIG_HEIGHT = 6;
RIG_STR = 6;

// Abstract "rings" carrying seats, and their distance off the carousel center
// as a fraction of radius.
RIG_RING_POSITIONS = [0.3, 0.6, 0.9];
RIG_MAX_R = 0.90 * CAROUSEL_INSCRIBED_RADIUS;
