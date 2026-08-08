//force parent buildings to check their ownership state

with (obj_building_parent) {
	//Handle steady building health decay
	//slow health decay over time
	if(is_owned_by_player == true){
		if (building_health > 0){
			building_health -= 1;
		} else {
			building_health = 0;
	}
}

// Penalty for Health Loss (I'm thinking the city can take it permanently.


	//Handle income based on building payouts
	if(is_owned_by_player == true) {
		if(building_health >= 30){ //stops generating cash if health drops below 31points
		global.player_cash += income_amount;
	}
}

}


//How many buildings exist vs how many the player owns
var total_buildings = instance_number(obj_building_parent);
var owned_count = 0

with(obj_building_parent) {
	if(is_owned_by_player == true) owned_count ++;
}

//Evaluate Game ending States
if (owned_count == total_buildings && total_buildings > 0) {
	game_over_state = "win";
} else if (global.player_cash < 0) {
	game_over_state = "lose";
}



//reset the alarm to loop forever

alarm[0]= payout_rate;
