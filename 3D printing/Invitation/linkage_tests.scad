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

*joint2();
module joint2(inner = true, outer=true){
	w=6;
	if(outer){
		difference(){
			union(){
				translate([0,-w/2,0]) cube([6,w,7]);
				translate([6,0,0]) cylinder(d=w, h=7, $fn=50);
			}
			translate([6,0,-0.01]) cylinder(d=4, h=1000, $fn=30);

			hull(){
				translate([4,-500,1]) cube([1000, 1000, 2]);
				translate([4, 0, 3]) rotate([0,-35,0]) translate([0,-500,-2]) cube([1000, 1000, 2]);
			}
		}
	}
	if (inner){
					translate([6,0,-0.01]) cylinder(d=3.2, h=7, $fn=30);
					translate([4.5,0,1.4]) cube([3, 5, 1.5]);
					translate([4.5,4,0]) cube([3, 1, 2]);
	}
}

module joint1(inner = true, outer=true){

	module topCone(){
		size = 8;
		translate([0,0,1]) cylinder(d1=size, d2=0, h=size/2, $fn = 50);
	}
	module bottomCone(){
		mirror([0,0,1]) topCone();
	}
	module throughHole(){
		cylinder(d=3.5, h=1000, $fn=50, center=true);
	}
	translate([0,0,5]) {
		if (outer){
			intersection(){
				difference(){
					cube([10,5,10], center=true);
					hull(){
						topCone();
						bottomCone();
					}
					throughHole();
				}

				if(true){
					union(){
						cylinder(d=8.6, h=1000, center=true, $fn=100);
						translate([-500,0,0]) cube(1000, center=true);
					}
				}
			}
		}
		if (inner){
			shrink = 0.8;

			intersection(){ //Core hinge structure
				cube([10,1000,10], center=true);
				union(){
					scale(shrink) 
					hull(){
						topCone();
						bottomCone();
					}
					scale(shrink) throughHole();
				}
			}

			translate([0,4,0]) cube([2, 4, 1.4], center=true);
			translate([0,5+1.5,-2.25]) cube([3,3,6], center=true);
		}
	}
}

module scissorsUnit(){
	l=20;
	translate([14,0,0]) cube([l-13, 3, 4]);
	translate([l+5,2,0]) joint1();

	translate([8,6.8,0]) cube([l-2, 3, 4]);

	//Lower bar
	translate([0,8,0]) joint1();
	translate([8,6.8,0]) cube([3, 8, 4]);
	translate([0,13,0]) cube([11, 3, 4]);

	//Upper bar
	hull(){
		translate([4,6.5,7]) cube([3,3,3]);
		translate([14,13,7]) cube([3,3,3]);
	}
	translate([14,13,0]) cube([3,3,7]);


	mirror([1,0,0]){
		translate([0,0,0]) cube([l, 3, 4]);
		translate([l+5,2,0]) joint1();

		translate([4,6.8,0]) cube([l+2, 3, 4]);

	}
}

module scissors(repeat = 2){
	for (i = [0:repeat-1]){
		translate([0,13*i,0]) render() scissorsUnit();
	}
}

scissors(2);

// joint1();
//linkage1();