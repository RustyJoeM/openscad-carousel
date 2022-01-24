// raise $fn before generating model parts for smoother rounded surfaces, columns, etc.
// our ideal number may vary - higher number may cause OpenSCAD to take longer to generate a model) as the first line of the bom script
$fn = 64;

// ----------------------------------------------------------------
    // let's assume that X = CAROUSEL_FACE_COUNT (see config.scad)
    // each of the following lines includes comment at the end of line
    // showing how many pieces need to be printed for the whole carousel model

// -------- walls -------------------------------------------------

// use <wall-core.scad>;
// printable_wall_core();   // X

// -------- struts ------------------------------------------------

    // beware, small difference between inner/outer wall pieces!
    // - inside of the wall part has tiny bit shorter right part of side struts
    //   (point of view when pegs visible)

// use <wall-struts.scad>;
// printable_door_strut();  // X
// printable_wall_struts_outer();   // X
// printable_wall_struts_inner();   // X

// -------- columns -----------------------------------------------

// use <wall-column.scad>;

    // either standalone parts:

// printable_column_half();    // 2*X
// printable_column_peg();     // 4*X

    // or single bom for each column

// printable_column_bom();     // X

// -------- roof --------------------------------------------------

// use <roof.scad>;
// printable_roof_segment();   // X

// -------- base --------------------------------------------------

// use <base.scad>;
    // base can be printed either in one piece (if it fits your 3D printer area)
// printable_base();   // 1
    // or separated into X-th fraction segment
// printable_base_segment();   // X
    // another alternative is bigger N-th pieces,
    // where N can be arbitrarily chosen from the interval of 1..X
// printable_base_segment(n = N);  // N

// -------- axle --------------------------------------------------

// use <axle.scad>;
// printable_axle_bearing();   // 1
    // next 1 item needs only ONE variant to be printed, either all-in-one piece:
// printable_axle_base(); // 1
    // OR axle core separated into twwo halves and joining pegs
// printable_axle_bom(); // 1

// -------- rig ---------------------------------------------------

// use <rig.scad>;
// printable_rig(); // 1
// printable_arm_head();   // 1
// printable_arm_cap_peg();    // 1

// -------- mounting lances ---------------------------------------

    // finally, for each of the models being mounted onto carusel following pieces:

// use <lance.scad>;
// printable_mounting_lance_cap();   // 1
// mounting_lance();   // 1
