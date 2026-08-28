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
