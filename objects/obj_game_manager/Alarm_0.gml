//Track Population cap
var base_cap = 5; //Base population cap due to Home Base
var total_cap_bonus= 0; //To allow buildings to increase the max population
var total_building_influence = 0;


//force parent buildings to check their ownership state

with (obj_building_parent) {
	//Handle steady building health decay
	//slow health decay over time
	if(is_owned_by_player == true && is_player_base == false){
		if (building_health > 0){
			building_health -= 1;
		} else {
			building_health = 0;
	}
}

// Penalty for Health Loss (I'm thinking the city can take it permanently.


	//Handle income based on building payouts ADD: New logic for Upgrades
	if(is_owned_by_player == true && building_health >= 30) {
		//stops generating cash if health drops below 31points
			
			var dynamic_income = income_amount * building_level;
			global.player_cash += dynamic_income;
			
			total_cap_bonus += (population_cap_bonus * building_level);
			
			
			//Old Population Logic that treated population like cash
			//var dynamic_population = population_generation * building_level;
			//global.player_population += dynamic_population;
			
			var dynamic_influence = influence_generation * building_level;
			global.player_influence += dynamic_influence;
			
		
		//Green Income text for each tick
			var txt = instance_create_layer(x, y - 20, "Instances", obj_floating_text);
			txt.text = "+$" + string(income_amount);
			txt.text_color = c_lime; //green for profit!
	}

}
//Adds new population max to total globally
global.player_population_max = base_cap + total_cap_bonus;

//Influence Math lives here

var population_influence_bonus = floor(global.player_population_max + 0.5);
var final_influence_tick = total_building_influence + population_influence_bonus;

global.player_influence += final_influence_tick

//Floating Purple text for influence 
if (final_influence_tick > 0) {
	var txt = instance_create_layer(150, 70, "instances", obj_floating_text);
	txt.text = "+" + string(final_influence_tick) + " Inf";
	txt.text_color = c_purple;
}

//How many buildings exist vs how many the player owns
var total_buildings = instance_number(obj_building_parent);
var owned_count = 0

with(obj_building_parent) {
	if(is_owned_by_player == true) owned_count ++;
}

//Holds Percentage of buildings owned for UI
if(total_buildings > 0) {
	global.city_owned_percent = floor((owned_count /total_buildings) * 100);
}


//Evaluate Game ending States
if (owned_count == total_buildings && total_buildings > 0) {
	game_over_state = "win";
} else if (global.player_cash < 0) {
	game_over_state = "lose";
}



//reset the alarm to loop forever

alarm[0]= payout_rate;
