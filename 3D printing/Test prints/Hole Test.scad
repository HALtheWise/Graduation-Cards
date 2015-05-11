module pattern() {
	difference(){
		hull(){
			translate([3, 5]) circle(3, center=false);
			translate([32, 5]) circle(6, center=false);
		}
	//square([36, 10]);
	for(x = [1:6]){
		translate([x*x*.7+x, 5]) circle(d = x, $fn=100);
	}
}
}

linear_extrude(2) pattern();