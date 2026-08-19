// Instructions check
if(show_instructions = true){
	//resets clock until player leaves instructions screen
alarm[2] = global.threat_check_rate;
exit;
}


//Defender units reduce the enemy's attack successes
var defense_mitigation = (global.garrison_units * 15);
//Government must overcome this defense
var final_threat_chance = max(0, global.enemy_threat - defense_mitigation);


// Roll a dice against the Active threat Meter to determine raids

if (random(100) <= final_threat_chance) {
	//Scan the map and create a list of valid player-owned targets
	var sabotage_targets = ds_list_create();
	
	with(obj_building_parent) {
		//only Target Normal Player Buildings (Home Base is safe from smaller raids
		if(is_owned_by_player == true && is_player_base == false) {
			ds_list_add(sabotage_targets, id);
		}
	}
	
	//Raid if the player owns at least one property
	if(ds_list_size(sabotage_targets) > 0) {
		var victim = ds_list_find_value(sabotage_targets, irandom(ds_list_size(sabotage_targets)- 1));
		
		//Damage the Target's building health down to 15%
		victim.building_health = 15;
		
		//reduce Threat level after a successful attack
		global.enemy_threat = max(0, global.enemy_threat - 30);
		
		//Sabotage Success sound effect
		audio_play_sound(snd_disaster, 12 , false);
		
		//Spawn a flashing alert pop up on top of Node
		var txt = instance_create_layer(victim.x, victim.y - 30, "Instances", obj_floating_text);
		txt.text= "ENEMY SABOTAGE!";
		txt.text_color = c_red;
	}
	//clear data stucture list
	ds_list_destroy(sabotage_targets);
} else {
	
	if(global.enemy_threat > 0 && random(100) > final_threat_chance && global.garrison_units > 0) {
	show_debug_message("Defenders have intercepted an enemy raid!");
}

}

alarm[2] = global.threat_check_rate;  