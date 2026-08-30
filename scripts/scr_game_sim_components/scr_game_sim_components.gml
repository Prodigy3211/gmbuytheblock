//Master System library

//Financial Multiplier
//Evaluated bones from Bookies and applies it to global cash
function component_get_financial_multiplier(){
	var bookie_data = variable_struct_get(global.faction_units, "bookie");
	var active_bookies = (bookie_data != undefined) ? bookie_data.count : 0;
	
	
	//every bookie gives a 10% bonus at this time
	return 1.0 + (active_bookies * 0.10);
}


//Calculate the government threat
//Looks through owned real estate and looks at number of spies to show a threat level
function component_calculate_government_threat(){
	var owned_count = 0;
	
	//Gather player property holdings
	with(obj_building_parent) {
		if(is_owned_by_player == true && is_player_base = false) {
			owned_count += 1;
		}
	}
	
	//Base Threat: Government Pressure increases by 8 points per structure owned
	var baseline_danger = owned_count * 8;
	
	//Fetch passive spy counter numbers
	var spy_data = variable_struct_get(global.faction_units, "spy");
	var active_spies = (spy_data != undefined) ? spy_data.count : 0;
	
	//Each spy passively suppressses 5 points of global threat
	var spy_suppression = active_spies * 5;
	
	//clam the resuls 
	return clamp(baseline_danger - spy_suppression, 0 , 100);
}

//Calculate Defenders
// A flat protection rating based on total defenders

function component_calculate_defense_mitigation () {
	//Total trained defenders?
	//Each unit provides a flat 15-point buffer
	return(global.garrison_units * 15);
}



//Logic for game to set up targets for attack

function component_get_random_player_targets(_count){
	var targets_list = ds_list_create();
	
	with(obj_building_parent){
		if(is_owned_by_player == true){
			ds_list_add(targets_list, id);
		}
	}
	
	//shuffle everthing so that the indexs are completely random
	ds_list_shuffle(targets_list);
	
	//If the list is larger than the strike count, truncate the list
	while(ds_list_size(targets_list) > _count) {
		ds_list_delete(targets_list, ds_list_size(targets_list) - 1);
	}
	
	return targets_list //Gives the list back to the event
	
}


//Loops through targeted buildings, sets their health, and spawns ui text

function component_damage_targets(_list,_target_health, _alert_text, _text_color) {
	var list_size = ds_list_size(_list);
	if(list_size <= 0) exit;
	
	for (var i = 0; i < list_size; i++) {
		var victim = ds_list_find_value(_list, i);
		
		//Apply building damage safely
		victim.building_health = _target_health;
		
		//spam local flashing warning text
		var txt = instance_create_layer(victim.x, victim.y - 30, "Instances",obj_floating_text);
		txt.text = _alert_text;
		txt.text_color = _text_color;
	}
}


//Natural Disaster controls

function component_trigger_natural_disaster(){
	//Fetch 1 random target across all owned buildings
	var victims = component_get_random_player_targets(1);
	
	if(ds_list_size(victims) > 0) {
		var target_building = ds_list_find_value(victims, 0);
		
		//Damage logic 60 health points removed
		var final_calculated_health = max(0, target_building.building_health - 60);
		
		//Script call send target and health info to the game manager
		component_damage_targets(victims, final_calculated_health, "ACT OF GOD",c_red);
		
		audio_play_sound(snd_disaster, 15, false);
	}
	
	ds_list_destroy(victims);
}



//Temple 10% tithe tax

function component_calculate_temple_tithe(){
	var cash_per_citizen = 12;
	var raw_tithe = (global.player_population_max * cash_per_citizen) * 0.10;
	return max(200, floor(raw_tithe));
}


//Review building type and level to determine it's impact on max population

function component_get_building_poulation_bonus(_object_index, _current_level, _base_bonus){
	//If building is a standard residence then this math applies
	
	if(_object_index == obj_residence) {
		switch(_current_level) {
			case 1: return 2; //Cramped Projects (West Side)
			case 2: return 6; //Apartment Complex (Downtown)
			default: return 15; //Tier 3+ Luxury High rises
		}
	}
	
	//Fallback calculation for other building types that may grant population
	return _base_bonus * _current_level;

}


//Gets influence cost of districts
function component_get_district_unlock_cost(_district_name) {
	if(variable_struct_exists(global.districts, _district_name)){
		var district_data = variable_struct_get(global.districts, _district_name);
		return district_data.cost;
	}
	return 0;
}

//Does player have enough influence??
function component_can_afford_district_unlock(_district_name){
	var target_cost = component_get_district_unlock_cost(_district_name);
	return (global.player_influence >= target_cost);
	
}


//Zone coordinates for creating districts!
function component_get_zone_by_coordinates(_x_pos){
	//Divid total map room width into 5 vertical Sectors
	var sector_width = room_width / 5;
	
	//determine which sector slot the coordinates sit within.(0 - 4)
	var sector_index = floor(_x_pos / sector_width);
	
	switch (sector_index) {
		case 0: return "West Side";
		case 1: return "Downtown";
		case 2: return "East Side";
		case 3: return "Uptown";
		default: return "Capitol Hill";
	}
}