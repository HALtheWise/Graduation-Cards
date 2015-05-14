use <libs/parametric_involute_gear_v5.0.scad>
use <pivots_module.scad>
include <constants.scad>

module gearTemplate(thick, teeth = 6)
{
	scale([.22,0.22,1]) gear (number_of_teeth = teeth,
		circular_pitch=1680,
		gear_thickness = thick,
		rim_thickness=thick,
		hub_thickness = thick,
		backlash=2,
		bore_diameter=0
		);
}

wiggle = 0.2;

module mainGear(screw = false) {
	thickness = 2;
	difference(){
		gearTemplate(thickness);
		
		if(!screw){
			pinHole(thickness);
		}
		else{
			screwHole(thickness, head=0.8);
		}
	}
	handleD = 2;
	handleH = 1.5;
	translate([5,0,thickness])
	cylinder(d=handleD, h = handleH);
}

module secondGear(hole = true){
	thickness = 1;

	difference(){
		gearTemplate(thickness);

		pinHole(2); //Should maybe be pinHole(thickness)

		if (hole){
			translate([5,0]) cylinder(h=1000, d=screwTightDiameter, center=true, $fn=20);
		}

	}

}

mainGear(screw = true);
//secondGear();

$fs = .1;