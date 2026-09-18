//These functions should track things that reward the player for owning a full sector

function component_calculate_master_payout(){
	var raw_payout = 0;
	
	//Sector Tracking counters
	
	var west_owned = 0;
	var downtown_owned = 0;
	var east_owned = 0;
	var uptown_owned = 0;
	var capitol_owned = 0;
	
	//Accumulate base income per district
	with (obj_building_parent){
		if(is_owned_by_player == true && is_player_base == false && building_health >= 30){
			var sect_mult = component_get_sector_cash_multiplier(building_district);
			var base_rate = income_amount;
			if(object_index == obj_temple){
				base_rate = component_calculate_temple_tithe();
			}
			
			var scaled_income = floor((base_rate * building_level) * sect_mult);
			
			raw_payout += scaled_income;
			
			//Tract ownership per sector
			switch(building_district) {
				case "West Side": west_owned++; break;
				case "Downtown": downtown_owned++; break;
				case "East Side": east_owned++; break;
				case "Uptown": uptown_owned++; break;
				case "Capitol Hill": capitol_owned++; break;
			}
		}
	}
	
	//Calculate district synergy bonus
	var synergy_bonus = 1.0;
	if(west_owned >= 3) synergy_bonus += (west_owned - 2) * 0.15;
	if(downtown_owned >= 3) synergy_bonus += (downtown_owned - 2) * 0.15;
	if(east_owned >= 3) synergy_bonus += (east_owned - 2) * 0.15;
	if(uptown_owned >= 3) synergy_bonus += (uptown_owned - 2) * 0.15;
	if(capitol_owned >= 3) synergy_bonus += (capitol_owned - 2) * 0.15;
	
	var financial_multiplier = component_get_financial_multiplier();
	
	return ceil((raw_payout * synergy_bonus) * financial_multiplier);
}