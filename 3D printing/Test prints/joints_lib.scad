//	Settings
	facets = 32;
	tolerance = 0.3;
	rotation_degrees = 20;

joint_examples_with_descriptions_in_comments();

module joint_examples_with_descriptions_in_comments()
	{
	//	Hypothetical build platform
	%	cube([100,100,0.1], center=true);
	//	A single end male connector, on its side
	translate([0,0,0]) joint_male(male_joint_width=3, male_joint_thickness=3, male_joint_height=10, side=true);
	//	A single end male connector, upright
	translate([-8,0,0]) joint_male(male_joint_width=3, male_joint_thickness=3, male_joint_height=10, side=false);
	//	A dual end male connector
	translate([-16,0,0]) 
		{
		for (i=[0,1]) mirror([0,i,0]) 
		translate([0,-10/2,0]) joint_male(male_joint_width=3, male_joint_thickness=3, male_joint_height=10, side=true);
		}
	//	A female connector, with 0 degrees range of movement
	translate([8,0,10/2]) 
		{
		difference()
			{
			cube([6,6,10], center=true);
			translate([0,0,2]) joint_male_negative(male_joint_width=3, male_joint_thickness=3, male_joint_height=10);
			}
		}
	//	A female connector, with 180 degrees range of movement
	translate([16,0,10/2]) 
		{
		difference()
			{
			cube([6,6,10], center=true); 
			translate([0,0,2]) 
				joint_male_negative(male_joint_width=3, male_joint_thickness=3, forward_rom=90, backward_rom=90, male_joint_height=10);
			}
		}
	//	A female connector, with a range of movement of 30 degrees forward and 90 degrees backward, and a clearance edge of 3mm
	translate([24,0,10/2]) 
		{
		difference()
			{
			cube([6,6,10], center=true); 
			translate([0,0,2]) 
				joint_male_negative(male_joint_width=3, male_joint_thickness=3, forward_rom=30, 
					backward_rom=90, clearance_edge=3, male_joint_height=10);
			}
		}
	}

module joint_male(male_joint_width=4, male_joint_thickness=4, male_joint_height=8, fn=facets, side=false)
	{
	if (side==false)
		{ joint_male_vertical(male_joint_width, male_joint_thickness, male_joint_height, fn=facets); }
	else if (side==true)
		{ joint_male_horizontal(male_joint_width, male_joint_thickness, male_joint_height, fn=facets); }
	}

module joint_female();
	{
	
	}

module joint_male_negative(male_joint_width=4, male_joint_thickness=5, male_joint_height=8, 
	forward_rom=0, backward_rom=0, clearance_edge=0, fn=facets)
	{
	//	Spherical axis/hinge bit
	for (i=[0,1]) mirror([i,0,0])
		translate([(male_joint_width/2-male_joint_thickness/8+tolerance), 0, 0]) rotate([0,90,0])
			sphere(r=male_joint_thickness/4+tolerance, $fn=fn/2);
	//	Rotated cutout
	rotate([0,-90,0]) difference()
		{
		linear_extrude(height=male_joint_width+tolerance*2+clearance_edge*2, center=true) 
			{
			//	Forward rotation
			hull()
				{
				circle(r=male_joint_thickness/2+tolerance, $fn=fn);
				for(i=[0:-forward_rom/rotation_degrees]) rotate([0,0,i*rotation_degrees]) 
					translate([male_joint_height+(male_joint_thickness/2+tolerance)*2,0,0]) 
					{ square((male_joint_thickness/2+tolerance)*2, center=true); }
				}
			//	Backward rotation
			mirror([0,1,0]) hull()
				{
				circle(r=male_joint_thickness/2+tolerance, $fn=fn);
				for(j=[0:-backward_rom/rotation_degrees]) rotate([0,0,j*rotation_degrees]) 
					translate([male_joint_height+(male_joint_thickness/2+tolerance)*2,0,0]) 
					{ square((male_joint_thickness/2+tolerance)*2, center=true); }
				}
			}
		for(i=[0,1]) mirror([0,0,i])
		translate([0,0,male_joint_width/2+tolerance]) 
			cylinder(r=male_joint_thickness, h=male_joint_width+tolerance*2, $fn=fn, center=false);
		}
	}

module joint_male_vertical(male_joint_width=4, male_joint_thickness=5, male_joint_height=8, fn=facets)
	{
	difference()
		{
		joint_male_solid(male_joint_width, male_joint_thickness, male_joint_height, fn);
		joint_male_cutout(male_joint_width, male_joint_thickness, male_joint_height, fn);
		}
	}

module joint_male_horizontal(male_joint_width=4, male_joint_thickness=5, male_joint_height=8, fn=facets)
	{
	translate([0,male_joint_height/2,male_joint_thickness/2]) rotate([90,0,0]) 
		joint_male_vertical(male_joint_width, male_joint_thickness, male_joint_height, fn);
	}

module joint_male_solid(male_joint_width=4, male_joint_thickness=5, male_joint_height=8, fn=facets)
	{
	difference()
		{
		union()
			{
			//	Main joint
			translate([0,0,(male_joint_height-male_joint_thickness/2)/2]) 
				cube([male_joint_width, male_joint_thickness, male_joint_height-male_joint_thickness/2], center=true);
			//	Rounded edge of joint
			translate([0,0,male_joint_height-male_joint_thickness/2]) rotate([0,90,0])
				cylinder(r=male_joint_thickness/2, h=male_joint_width, center=true,$fn=fn);
			//	Sphere/buds, on either side
			for (i=[0,1])
				{
				mirror([i,0,0]) translate([(male_joint_width/2-male_joint_thickness/8+tolerance), 0, male_joint_height-male_joint_thickness/2]) 
					sphere(r=male_joint_thickness/4, $fn=fn/2);
				}
			}
		//	In some circumstances, the rounded edge can protrude below the build surface, this cuts that off
		if (male_joint_thickness>male_joint_height)
			{
			translate([0,0,-male_joint_height*1.1/2]) 
				cube([male_joint_width+male_joint_thickness/2, male_joint_thickness+1, male_joint_height*1.1], center=true);
			}
		}
	}

module joint_male_cutout(male_joint_width=4, male_joint_thickness=5, male_joint_height=8, fn=facets)
	{
	//	Middle cutout - this is important so that the part will flex as it is inserted.  We need to consider several uses

	//	Thin, but wide male connector
	if (male_joint_height > male_joint_width*1.5 && male_joint_width > male_joint_thickness*1.5)
		{ 
		translate([0,0,male_joint_height*3/2-male_joint_width]) 
			cube([male_joint_width/3, male_joint_thickness+1, male_joint_height], center=true); 
		}
	//	Thick, but narrow male connector
	else if (male_joint_height-male_joint_thickness > male_joint_width && male_joint_width < male_joint_thickness)
		{ 
		translate([0,0,male_joint_height*3/2-male_joint_thickness]) 
			cube([male_joint_width/4, male_joint_thickness+1, male_joint_height], center=true); 
		}
	//	Square footprint male connector
	else if (male_joint_height-male_joint_thickness > male_joint_width && male_joint_width == male_joint_thickness)
		{ 
		translate([0,0,male_joint_height*3/2-male_joint_thickness*1.25]) 
			cube([male_joint_width/4, male_joint_thickness+1, male_joint_height], center=true); 
		}
	//	Cases where the connector is really short
	else
		{
		translate([0,0,male_joint_height/2+male_joint_height*0.25]) 
			cube([male_joint_width/4, male_joint_thickness+1, male_joint_height], center=true); 
		}

	}