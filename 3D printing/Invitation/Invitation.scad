include <MCAD/units.scad>
include <constants.scad>
use <pivots_module.scad>
use <gears_module.scad>

module paperLayer() {
	cube([5.5*inch, 4.25*inch, 0.1*inch]);
}

baseThickness = 2.4*mm;

*color("lightblue") translate([0,0,baseThickness]) paperLayer();

*crank();
module crank() {
	thickness = 2;
	length = 15;
	difference(){
		hull(){
			cylinder(h=thickness, d=8, center=false, $fn=20);
			translate([length, 0,0]) cylinder(h=thickness, d=3, center=false, $fn=20);
		}
		screwHole(thickness);
	}
	translate([length,0,thickness]){
		cylinder(h=4, d=2, center=false, $fn=20);
	}
}
*gear1();
module gear1(){
	gearTemplate(baseThickness, 6);
	translate([0,0,baseThickness]) integratedPin();
}

*gear2();
module gear2(){
	gearTemplate(baseThickness, 8);
	translate([0,0,baseThickness]) integratedPin(1);
}

translate([0,0,baseThickness+paperThickness]) !microCap();
module microCap(){
	difference(){
		cylinder(h=.8, d1=holepunch+2, d2=holepunch, center=false, $fn=20);
		pinHole();
	}
}

*translate([0,0,-4]) gear3();
module gear3(){
	gearTemplate(baseThickness, 6);
	translate([0,0,baseThickness]) integratedPin(camArmThickness);	
}

camArmThickness = 1.4;
%translate([8,-18,0]) camArm();
module camArm(){
	length = 3.5;
	difference(){
		hull(){
			cylinder(h=camArmThickness, d=8, center=false, $fn=20);
			translate([length, 0,0]) cylinder(h=camArmThickness, d=3, center=false, $fn=20);
		}
		pinHole(2.6);
	}
	translate([length,0,camArmThickness]){
		integratedPin(2, friction = false);
	}	
}


%translate([0,0,-baseThickness]) microBase();
module microBase(){
	union(){
		cylinder(h=.8, d=holepunch+4, center=false, $fn=20);
		translate([0,0,0.8]) integratedPin(armThickness);
	}
}

armThickness = 2;
!upperArm();
module upperArm(){
	upperArmLen = 12;
	difference(){
		union(){
			hull(){
				cylinder(h=armThickness, d = 6, $fn=20);
				translate([upperArmLen,0,0]) cylinder(h=armThickness, d = 6, $fn=20);
			}
			hull(){ //Bicep highlight
				cylinder(h=armThickness, d = 6, $fn=20);
				translate([upperArmLen*0.4,0,0]) cylinder(h=armThickness, d = 6, $fn=20);
				translate([upperArmLen/3,0,armThickness]) cube(size=[upperArmLen/4,1,2*armThickness], center=true);
			}
		}
		screwHole(armThickness+4, head=3.0);
	}
	translate([upperArmLen,0,armThickness]) integratedPin(armThickness+1, friction= false);
}

translate([12,0,5]) lowerArm();

module lowerArm() {
	lowerArmLen1 = 14;
	lowerArmLen2 = 12;
	difference(){
		union(){ //Entire solid arm
			union(){ //Forearm
				hull(){//Main forearm
					cylinder(h=armThickness, d = 5.8, $fn=20);
					translate([0,lowerArmLen1,0]) cylinder(h=armThickness *0.6, d = 4, $fn=20);
				}
				translate([0, lowerArmLen1+4,0]) rotate([0,0,20]) { //Hand
					if (false){ // Use "E" hand
						#scale(0.9) translate([3.5,-5.3,0]) rotate([0,0,90]) linear_extrude(armThickness) text("E");
					}
					else{
						difference(){
							cylinder(h=armThickness*0.6, r=5, center=false, $fn=40);
							translate([0,2,0]) cylinder(h=1000, r=4, center=true, $fn=40);
						}
					}
				}
				hull(){ //Forearm feature
					cylinder(h=.01, d = 5, $fn=20);
					translate([0,lowerArmLen1,0]) cylinder(h=.01, d = 2, $fn=20);
					translate([0,lowerArmLen1/2,armThickness]) cube(size=[1,lowerArmLen1/4,1*armThickness], center=true);
				}
			}
			rotate([0,0,-24]) difference(){ //Hindarm
				union(){
					hull(){//Main hindarm
						cylinder(h=armThickness*0.8, d = 4, $fn=20);
						translate([0,-lowerArmLen2,0]) cylinder(h=armThickness *0.4, d = 4, $fn=20);
					}
					translate([0,-lowerArmLen2,0]) cylinder(h=armThickness*0.8, d=holeD+1.6, center=false, $fn=40);
				}
				translate([0,-lowerArmLen2,0]) screwHole();
			}
		}

		screwHole(armThickness);
	}

}