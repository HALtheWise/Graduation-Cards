module paperMount(){
	width = 20;
	height = 2;
	taperdeg = 20;

	translate([0,0,-height])
	cylinder(h=height, d1=width, d2 = width - 2 * height * cos(taperdeg), center=false);
}

module peg(axleLen){ //peg, including clip
	axleD = 2;
	cylinder(d = axleD, h = axleLen);
	
	clipHeight = .3;
	clipRadius = .5;
	translate([0,0,axleLen]) 
	cylinder(h=clipHeight, d1=clipOuterD, d2=axleD);

	clipOuterD = axleD+2*clipRadius;

	printangle = 60;

	translate([0,0,axleLen]) mirror([0,0,1]) cylinder(d1 = clipOuterD ,d2 = axleD, h = cos(printangle) * (clipOuterD - axleD));
}

module pivot(axleLen = 3){
	difference(){ //Peg with slot
		peg(axleLen);

		sliceWidth = 1;
		cube([100, sliceWidth, 100], center = true);
	}
}

use <parametric_involute_gear_v5.0.scad>

	module gearTemplate(thick)
	{
		scale([.22,0.22,1]) gear (number_of_teeth = 15,
			circular_pitch=700,
			gear_thickness = thick,
			rim_thickness=thick,
			hub_thickness = thick,
			backlash=2,
			bore_diameter=0
			);
	}

module mainGear() {
	thickness = 2;
	difference(){
		gearTemplate(thickness);
		
		minkowski(){
			peg(thickness);
			sphere(0.2);
		}
	}
	handleD = 1;
	handleH = 1;
	translate([5,0,thickness])
	cylinder(d=handleD, h = handleH);
}

module secondGear(){
	thickness = 1;

	difference(){
		gearTemplate(thickness);
		
		minkowski(){
			peg(thickness);
			sphere(0.2);
		}
	}


	translate([4,0,thickness]){
		scale(.4) pivot(2);
	}

}

mainGear();
translate([13,0]) secondGear();

$fs = .1;

color("red") {
	pivot(2);
	paperMount();
}
color("red") translate([13,0]) {
	pivot(1);
	paperMount(1);
}