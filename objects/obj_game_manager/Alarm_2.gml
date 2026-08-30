// Instructions check
if(show_instructions = true){
	//resets clock until player leaves instructions screen
alarm[2] = global.threat_check_rate;
exit;
}


//Grab data from game sim script

global.enemy_threat = component_calculate_government_threat();
var defense_shield = component_calculate_defense_mitigation();

//Calculate final break-trhough attack probability
var final_threat_chance = max(0, global.enemy_threat - defense_shield);

//Roll tatical sabotage dice


//Base Government Anger
//var owned_count = 0;

// Roll a dice against the Active threat Meter to determine raids

if (random(100) <= final_threat_chance) {
	//Determine raid intensisty based on current threat level
	var raid_intensity = 1;
	var display_msg = "ENEMY SABOTAGE!";
	
	if(global.enemy_threat >= 80){
		raid_intensity = 4; //Mass Critical Sector Raid
		display_msg = "SECTOR RAIDED!";
	} else if global.enemy_threat >= 50{
		raid_intensity = 2; //Coordinated Strike
	}
	
	//Script call pre sorted random victims
	var victims = component_get_random_player_targets(raid_intensity);
	
	if(ds_list_size(victims) > 0 ) {
		//Script call damage all selected buildings to 15% health in one command
		component_damage_targets(victims, 15, display_msg, c_red);
		
		audio_play_sound(snd_disaster, 12, false);
		
		//Reduce threat level
		var threat_vent = (global.enemy_threat >= 80) ? 60 : 30;
		global.enemy_threat = max(0, global.enemy_threat - threat_vent);
	}
	
	ds_list_destroy(victims);
	
} else {
	
	if(global.enemy_threat > 0 && random(100) > final_threat_chance && global.garrison_units > 0) {
	//Script call Grab a safe building
	var safe_spot = component_get_random_player_targets(1);
	
	if (ds_list_size(safe_spot) > 0) {
		
		var picked_instance = ds_list_find_value(safe_spot, 0);
		
		//script call pass the current health so that it spawns the text without being damanged
		component_damage_targets(safe_spot, picked_instance.building_health, "RAID INTERCEPT", c_aqua)
		
		audio_play_sound(snd_defender, 10 , false);
		
	}
	
	ds_list_destroy(safe_spot);
}

}

alarm[2] = global.threat_check_rate;  