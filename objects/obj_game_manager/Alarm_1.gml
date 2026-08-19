// Instructions check
if(show_instructions = true){
	//resets clock until player leaves instructions screen
alarm[1] = 1500
exit;
}

//30% chance of a random event trigger
if (random(100) <= 30) {
	//create an empty list to hold valid player owned buildings to target
	var player_buildings = ds_list_create();
	
	//scan the map and add only player owned buildings to the list
	with (obj_building_parent) {
		if(is_owned_by_player == true){
			ds_list_add(player_buildings,id);
		}
	}
	
	//pick a random building to hurt from the list
	if(ds_list_size(player_buildings) > 0) {
		var random_index = irandom(ds_list_size(player_buildings) - 1);
		var random_target = ds_list_find_value(player_buildings, random_index);
	
	
		//deal 60 points of damage to target building. OUCH!
		random_target.building_health -= 60;
		audio_play_sound(snd_loss, 15, false);
		
		var txt = instance_create_layer(random_target.x, random_target.y - 30, "Instances", obj_floating_text);
		txt.text= "ACT OF GOD!";
		txt.text_color = c_red;
	}
	//Destroy the data structure to prevent memory leaks
	ds_list_destroy(player_buildings);
}

//reset clock
alarm[1] = 1500;