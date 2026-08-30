function purchase_faction_unit(_unit_key, _building_inst){
	
	var inst = (_building_inst != undefined) ? _building_inst : global.selected_building;
	
	if (inst == noone) return false;
	
	//Look up of specific unit struct
	var unit_data = variable_struct_get(global.faction_units, _unit_key);
	
	// EXIT IF KEY NAME IS MISSPELLED
	if (unit_data == undefined) return false;
	
	// Fetch runtime cash and population cap thresholds
	var current_cash_cost = unit_data.cash_cost;
	var current_pop_cost = unit_data.pop_cost;
	
	var has_enough_cash = (global.player_cash >= current_cash_cost);
	var has_enough_room = (global.player_population + current_pop_cost <= global.player_population_max);
	
	
	//process transaction if conditions match
	if (has_enough_cash && has_enough_room) {
		
		//Deduct approriate amounts
		global.player_cash -= current_cash_cost;
		global.player_population += current_pop_cost;
		
		//increment the unit count inside of the struct
		unit_data.count += 1;
		
		//Scale up the cost of each unit by 40%
		unit_data.cash_cost = ceil(current_cash_cost * 1.4);
		
		if(_unit_key == "recruiter"){
			inst.recruiter_count += 1;
			inst.recruiter_cost = unit_data.cash_cost;
			audio_play_sound(snd_recruit, 10, false);
		}
		
		if(_unit_key == "defender"){
			global.garrison_units += 1;
			audio_play_sound(snd_defender, 10 , false);
		}
		
		//floating text confirmation over selected building
		var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
		txt.text = "-$" + string(current_cash_cost) + " " + string_upper(_unit_key);
		txt.text_color = c_red;
		
		return true; //Transaction complete!
	}
	
	//DEBUG IF TRANSACTION FAILS
	if(!has_enough_room){
		show_debug_message("FAILED: population cap hit! Buy more housing");
	}
	
	return false; //Transaction blocked!

}