use <wall-core.scad>;
use <wall-struts.scad>;
use <wall-column.scad>;
use <wall-roof.scad>;
use <base.scad>;
use <axle.scad>;

// raise $fn before generating model parts for smoother rounded surfaces, columns, etc.
// our ideal number may vary - higher number may cause OpenSCAD to take longer to generate a model) as the first line of the bom script
$fn = 64;

// ----------------------------------------------------------------
    // let's assume that X = CAROUSEL_FACE_COUNT (see config.scad)
    // each of the following lines includes comment at the end of line
    // showing how many pieces need to be printed for the whole carousel model

// printable_wall_core();   // X
// printable_door_strut();  // X

    // beware, small difference between following two pieces!
    // - inside of the wall part has tiny bit shorter right part of side struts
    //   (point of view when pegs visible)

// printable_wall_struts_outer();   // X
// printable_wall_struts_inner();   // X

// printable_column_half();    // 2*X
// printable_column_peg();     // 4*X

// printable_roof_segment();   // X

    // base can be printed either in one piece (if it fits your 3D printer area)

// printable_base();   // 1

    // or separated into X-th fraction segment

// printable_base_segment();   // X

    // or bigger N-th pieces, where N can be arbitrarily chosen from the interval of 1..X

// printable_base_segment(n = N);  // N

// printable_axle_bearing();   // 1

    // next item needs only ONE variant to be printed, either all-in-one piece:

// printable_axle_base(); // 1

    // OR axle core separated into twwo halves and joining pegs

// printable_axle_bom(); // 1
