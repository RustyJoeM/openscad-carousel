# openscad-carousel

Please note that this is **WORK IN PROGRESS**! Model may and most probably will change extensively without any backward parts compatibility!

This tiny repo consists of [OpenSCAD](https://openscad.org) scripts that can generate a 3D model of a rotating carousel.

Intent is to have a core model for 3D printing, that allows to add any custom separately created "seats" into the rotating rig space of carousel.

It should be easy to customize resulting model (e.g. total size, height, number of walls/faces of the carousel N-gon, etc.) using the "configuration" constants in the script code.

# Customizing model

You can use file [carousel/config.scad](carousel/config.scad) to modify some features of the carousel, like total dimensions, number of walls making the whole N-gon shell, etc. See file contents and comments for details.

# 3D printing

See [carousel/bom.scad](carousel/bom.scad) file for details on how many pieces and which modules need to be printed.

# Mounting example

See [mounting-example.scad](mounting-example.scad) file for a simple example on how to easily attach own module/object into carousel for testing/visualization purposes.

# TODO

- decide on where to fixate the rotating bearing
- fix rig
- fix axle
- finalize, humanize, clean-up the all modules
