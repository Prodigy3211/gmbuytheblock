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

//reset the alarm to loop forever

alarm[0]= payout_rate;