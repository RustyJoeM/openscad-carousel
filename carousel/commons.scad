module rect_prism(width, height, p0, p1) {
    dir = p1 - p0;
    h = norm(dir);
    if (dir[0] == 0 && dir[1] == 0) {
        // no transformation necessary
        translate(p0)
        translate([0, 0, h/2])
        cube([size, size, h], center = true);
    }
    else {
        w  = dir / h;
        u0 = cross(w, [0,0,1]);
        u  = u0 / norm(u0);
        v0 = cross(w, u);
        v  = v0 / norm(v0);
        multmatrix(m=[[u[0], v[0], w[0], p0.x],
                      [u[1], v[1], w[1], p0.y],
                      [u[2], v[2], w[2], p0.z],
                      [0,    0,    0,    1]])
        translate([0, 0, h/2])
        cube([width, height, h], center = true);
    }
}

module square_prism(size, p0, p1) {
    rect_prism(size, size, p0, p1);
}

module point_plate(thickness, point_array, indices, fn = 8) {
    hull() {
        for (i = indices) {
            translate(point_array[i])
            sphere(d = thickness, $fn = fn);
        }
    }
}
