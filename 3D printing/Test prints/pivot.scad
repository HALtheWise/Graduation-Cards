module paperMount(){
	width = 8;
	height = .6;
	taperdeg = 20;

	translate([0,0,-height])
	difference(){
		cylinder(h=height, d1=width, d2 = width - 2 * height * cos(taperdeg), center=false); //Marker for center
		translate([0,0,height/2]) cylinder(h=height, d=.2);
		translate([0,0,height-.1]) pinHole();
	}
}

axleD = 3;

clipHeight = .8;
clipRadius = 1.5;

module separatePin(axleLen = 3){
	rotate([180]) translate([0,0,-axleLen]){
		cylinder(h=axleLen, d=axleD);
		cylinder(h=clipHeight, d=axleD+2*clipRadius);
	}
}

module pinHole(axleLen = 3){
	rotate([180]) translate([0,0,-axleLen]){
		cylinder(h=axleLen + .01, d=axleD + 2*wiggle);
		translate([0,0,-.01]) cylinder(h=clipHeight + wiggle+.01, d=axleD+2*clipRadius + 2*wiggle);
	}
}

wiggle = .3;



$fs = .1;

color("lightgreen") {
	//	pivot(2);
	paperMount();
}
*color("lightgreen") translate([13,0]) {
	//	pivot(1);
	paperMount(axleLen=1);
}

*rotate([180]){
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

