include <MCAD/units.scad>
include <constants.scad>

module paperLayer() {
	cube([5.5*inch, 4.25*inch, 0.1*inch]);
}

paperLayer();