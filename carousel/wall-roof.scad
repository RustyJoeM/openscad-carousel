// module roof() {
//         // roof part
//         OH = 0.1 * FACE_APOTHEM_LEN;
//         RHR = 0.8 * FACE_APOTHEM_LEN;
//         rpts = [
//             [-FX, -OH, FF*FY],  // 0
//             [  0, -OH,    FY],  // 1
//             [+FX, -OH, FF*FY],  // 2
//             [+FX, 0, FF*FY],    // 3
//             [  0, +0.25*FACE_APOTHEM_LEN, FY],    // 4
//             [-FX, 0, FF*FY],    // 5
//             [+0.2*FX, RHR, ROOF_HEIGHT],    // 6
//             [      0, RHR, ROOF_HEIGHT],    // 7
//             [-0.2*FX, RHR, ROOF_HEIGHT],    // 8
//         ];
//         *color("PaleGreen")
//         translate([0, 0, BEAM_SIZE/2])
//         {
//             point_plate(ROOF_THICKNESS, [rpts[0], rpts[1], rpts[4], rpts[5]]);
//             point_plate(ROOF_THICKNESS, [rpts[1], rpts[2], rpts[3], rpts[4]]);
//             point_plate(ROOF_THICKNESS, [rpts[3], rpts[4], rpts[6]]);
//             point_plate(ROOF_THICKNESS, [rpts[4], rpts[5], rpts[8]]);
//             point_plate(ROOF_THICKNESS, [rpts[4], rpts[8], rpts[6]]);
//             translate([0, 0, ROOF_THICKNESS]) {
//                 square_prism(ROOF_THICKNESS, [rpts[1], rpts[4]]);
//                 square_prism(ROOF_THICKNESS, [rpts[5], rpts[8]]);
//             }
//         }
//     }
// }