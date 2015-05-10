use <parametric_involute_gear_v5.0.scad>
use <pivot.scad>

module gearTemplate(thick)
{
	scale([.22,0.22,1]) gear (number_of_teeth = 6,
		circular_pitch=1680,
		gear_thickness = thick,
		rim_thickness=thick,
		hub_thickness = thick,
		backlash=2,
		bore_diameter=0
		);
}

wiggle = 0.2;

module mainGear() {
	thickness = 2;
	difference(){
		gearTemplate(thickness);
		
		pinHole(thickness);

		*minkowski(){
			peg(thickness);
			sphere(wiggle);
		}
	}
	handleD = 1;
	handleH = 1;
	translate([5,0,thickness])
	cylinder(d=handleD, h = handleH);
}

module secondGear(){
	thickness = 1;
	rotate([0,0,30]){

		difference(){
			gearTemplate(thickness);

		pinHole(2); //Should maybe be pinHole(thickness)

			*minkowski(){
				peg(thickness);
				sphere(wiggle);
			}
		}


		translate([4,0,thickness]){
			scale(.4) pivot(2);
		}
	}
}

mainGear();
translate([13,0]) secondGear();

$fs = .1;