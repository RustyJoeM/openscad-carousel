// Import carousel core file.
use <carousel/carousel.scad>;

// Main carousel object.
carousel_mounted();

// This is a custom seat model to be added to carousel.
// Might have been imported from other file as well...
module my_seat() {
    translate([0, 0, 4])
    sphere(4);
}

// Import helpers for automatic positioning of own modules on carousel.
use <carousel/helpers.scad>;

// Add several instances of my custom seat to odd/even positions.
carousel_scattered() color("blue") my_seat();

// Or add single item to explicit slot...
carousel_slotted(1, 1) color("green") my_seat();
carousel_slotted(2, 4) color("red") my_seat();
