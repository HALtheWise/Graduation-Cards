use <pivots_module.scad>
include <constants.scad>

module linkage1() {
	difference(){
		length = 30;
		width = 8;
		height = 3;
	hull(){
		cylinder(h=height, d=width, $fn=20);
		translate([length,0,0]) cylinder(h=height, d=width, $fn=20);
	}
	hole(.8, height);
	translate([length,0,0]) hole(.8, height);
}
}

wiggle = 0.2;

module hole(d, l){
	scale([d,d,1])
	minkowski(){
		peg(l);
		sphere(wiggle);
	}
}

linkage1();