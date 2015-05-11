include <constants.scad>

module tinyMount(
	axleLen = 2, 
	screwHole = false, 
	sparse = true, 
	base = true){

	thickness = .6;
	paper = 0.4;
	holepunch = 5;//mm
	r = 10;

	difference(){
		union(){
			cylinder(h=thickness + paper, d=holepunch, $fn=60);
			translate([0,0,thickness+paper]) cylinder(h=axleLen, d=axleD, $fn=60);

			l = [[r, 0], [0, r], [-r, 0], [0, -r]];


			if(base)
			{	curveRadius = 1;
				if(!sparse){
					hull()
					for (x1 = l){
						translate(x1) cylinder(h=thickness, r=curveRadius, center=false, $fn=20);
					}
				}
				else{
					for (x1 = l){
						for (x2 = l){
							hull(){
								translate(x1) cylinder(h=thickness, r=curveRadius, center=false, $fn=20);
								translate(x2) cylinder(h=thickness, r=curveRadius, center=false, $fn=20);
							}
						}
					}
				}
			}
		}
		if (screwHole) {
			cylinder(h=1000, d = screwTightDiameter, center=true, $fn=20);
		}
	}
}

module testTinyMount() {
	tinyMount(screwHole = false);
	translate([14,14]) tinyMount(screwHole = true);
	translate([-14,-14]) tinyMount(screwHole = true);
}
!testTinyMount();

module paperMount(){
	width = 8;
	height = .6;
	taperdeg = 20;

	translate([0,0,-height])
	difference(){
		cylinder(h=height, d1=width, d2 = width - 2 * height * cos(taperdeg), center=false); 
		//Marker for center
		translate([0,0,height/2]) cylinder(h=height, d=.2);
		//Indent for pin
		translate([0,0,height-.2]) pinHole();
	}
}

axleD = 3;

clipHeight = .8;
clipRadius = 1.5;

module separatePin(axleLen = 2){
	rotate([180]) translate([0,0,-axleLen]){
		cylinder(h=axleLen, d=axleD);
		cylinder(h=clipHeight, d=axleD+2*clipRadius);
	}
}

module pinHole(axleLen = 2){
	rotate([180]) translate([0,0,-axleLen]){
		cylinder(h=axleLen + .01, d=axleD + 2*wiggle);
		translate([0,0,-.01]) cylinder(h=clipHeight + wiggle+.01, d=axleD+2*clipRadius + 2*wiggle);
	}
}

wiggle = .3;



$fs = .1;

!color("lightgreen") {
	//	pivot(2);
	paperMount();
}
*color("lightgreen") translate([13,0]) {
	//	pivot(1);
	paperMount(axleLen=1);
}

rotate([180]){
	separatePin();
	//	#pinHole();
}

// module peg(axleLen){ //peg, including clip
	// 	cylinder(d = axleD, h = axleLen);
	
	// 	clipHeight = .3;
	// 	clipRadius = .5;
	// 	translate([0,0,axleLen]) 
	// 	cylinder(h=clipHeight, d1=clipOuterD, d2=axleD);

	// 	clipOuterD = axleD+2*clipRadius;

	// 	printangle = 60;

	// 	translate([0,0,axleLen]) mirror([0,0,1]) cylinder(d1 = clipOuterD ,d2 = axleD, h = cos(printangle) * (clipOuterD - axleD));
	// }

	// module pivot(axleLen = 3){
		// 	difference(){ //Peg with slot
			// 		peg(axleLen);

			// 		sliceWidth = 2;
			// 		cube([100, sliceWidth, 100], center = true);
			// 	}
			// }

