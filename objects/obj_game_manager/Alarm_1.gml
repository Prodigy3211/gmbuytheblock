//30% chance of a random event trigger
if (random(100) <=30) {
	
	//pick a random building to hurt
	var random_target = instance_find(obj_building_parent, irandom(instance_number(obj_building_parent) - 1 ));
	
	if (random_target != noone) {
		//deal 40 points of damage to target building. OUCH!
		random_target.building_health -= 40;
		show_debug_message("Disaster has struck a building, health dropped");
		
	}
}

//reset clock
alarm[1] = 600;