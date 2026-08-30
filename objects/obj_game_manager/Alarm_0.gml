// Instructions check
if(show_instructions = true){
	//resets clock until player leaves instructions screen
alarm[0] = payout_rate; 
exit;
}

//Track Population cap
var base_cap = 0; //Base population cap due to Home Base
var total_cap_bonus= 0; //To allow buildings to increase the max population
var total_building_influence = 0;

//Tracks all live cash flow from properties
var total_building_cash = 0;


//force parent buildings to check their ownership state

with (obj_building_parent) {
	//Handle steady building health decay
	//slow health decay over time
	if(is_owned_by_player == true && is_player_base == false){
		if (building_health > 0) building_health -= 1;
	
		
		//Emminent Domain! The City will take their buildings back from you.
		if (building_health <= 0) {
			is_owned_by_player = false;
			building_health = 100;
			image_blend = c_dkgray;
			building_level= 1;
			
			//NEED TO ADD A SOUND HERE
			//audio_play_sound(snd_,10, false);
			
			//Alert popup for lost property
			var txt = instance_create_layer(x,y - 20, "Instances", obj_floating_text);
			txt.text = "CITY HAS RECLAIMED ASSET!";
			txt.text_color = c_red;
		}
		
	
}

// Penalty for Health Loss (I'm thinking the city can take it permanently.


	//Handle income based on building payouts ADD: New logic for Upgrades
	if(is_owned_by_player == true && building_health >= 30) {
		//stops generating cash if health drops below 31points
			
			//dynamic revebye evaluation
			if (object_index == obj_temple){
				base_income_rate = component_calculate_temple_tithe();
			}
			
			var dynamic_income = income_amount * building_level;
			
			total_building_cash += dynamic_income;
			
			//Dynamic housing pool... Will help with Temple curve based on population
			total_cap_bonus += component_get_building_poulation_bonus(object_index, building_level, population_cap_bonus);
			
			
			//Old Population Logic that treated population like cash
			//var dynamic_population = population_generation * building_level;
			//global.player_population += dynamic_population;
			
			var dynamic_influence = influence_generation * building_level;
			
			
			//Impact of Recruiters
			if (variable_instance_exists(id, "recruiter_count")){
				//every active recruiter should add x amount of influencer points per tick
				dynamic_influence += (recruiter_count * 3);
			}
			
			total_building_influence += dynamic_influence;
	
		
		//Green Income text for each tick
			var txt = instance_create_layer(x, y - 20, "Instances", obj_floating_text);
			txt.text = "+$" + string(dynamic_income);
			txt.text_color = c_lime; //green for profit!
	}

}


//Bookie and cash scripts

var financial_multiplier = component_get_financial_multiplier();
var final_cash_payout = ceil(total_building_cash * financial_multiplier);

global.player_cash += final_cash_payout;

var baseline_homebase_cap = 10;
global.player_population_max = baseline_homebase_cap + total_cap_bonus;

var population_influence_bonus = floor(global.player_population_max * 0.5);
var final_influence_tick = total_building_influence + population_influence_bonus;

global.player_influence += final_influence_tick;

//Save global tickers for dashboard
global.net_cash_tick = final_cash_payout;
global.net_influence_tick = final_influence_tick;

//Track visual notification ticks if you own bookies
if (financial_multiplier > 1.0 && total_building_cash > 0) {
	global.hud_bookie_bonus = final_cash_payout - total_building_cash;
	global.hud_bonus_timer = 90;
}

if (final_influence_tick > 0) {
	var txt = instance_create_layer(150, 70, "Instances", obj_floating_text);
	txt.text = "+" + string(final_influence_tick) + "Inf";
	txt.text_colour = c_purple;
}


//Accountant Logic


//// Pull accountant/bookie count from central data
//var bookie_data = variable_struct_get(global.faction_units, "bookie");
//var active_bookies = (bookie_data != undefined) ? bookie_data.count : 0;


////each bookie adds 10% efficiency bonus to total cash
//var financial_multiplier = 1.0 + (active_bookies * 0.10);
//var final_cash_payout = ceil(total_building_cash * financial_multiplier);


////Finalize global resources
//global.player_cash += final_cash_payout;
//global.player_influence += total_building_influence;

////Population Cap update
//global.player_population_max = 5 + total_cap_bonus; // 5 is the starting Population cap


////Corporate bonus feedback
////If we have bookies and earned money, we can display the efficiency bonus
//if(active_bookies > 0 && total_building_cash > 0) {
//	var hud_txt = instance_create_layer( room_width / 2 , 60, "Instances", obj_floating_text);
//	hud_txt.text = "Bookie Efficiency:  +$" + string(final_cash_payout - total_building_cash);
//	hud_txt.text_colour = c_yellow;
//}

// Homebase Game Loss Trigger
with(obj_player_base) {
	
	//If sabotage or natural disaster destroys base it will flip to city owned
	if(building_health <= 0){
		is_owned_by_player = false;
		building_health = 100;
		image_blend = c_dkgray;
		
		//Trigger Faction Defeat
		obj_game_manager.game_over_state = "lose";
		audio_play_sound(snd_loss, 90, false);
		
		//Major flashing alert
		var txt = instance_create_layer(x, y -20, "Instances", obj_floating_text);
		txt.text = "HEADQUARTER DESTROYED";
		txt.text_color = c_red;
	}
}




////Adds new population max to total globally
//global.player_population_max = base_cap + total_cap_bonus;

////Add Value transactions to Economy
//global.player_cash += total_building_cash;

////Influence Math lives here

//var population_influence_bonus = floor(global.player_population_max + 0.5);
//var final_influence_tick = total_building_influence + population_influence_bonus;

//global.player_influence += final_influence_tick

//saving global sum values to global tickets
//global.net_cash_tick = total_building_cash;
//global.net_influence_tick = final_influence_tick;



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
	audio_play_sound(snd_win, 90, false);
} else if (global.city_owned_percent == 0) {
	game_over_state = "lose";
}

//The Enemy Doesnt Want you to win!
if (game_over_state == "playing") {
//Tiny fraction to threat meter based on your buyout %
	global.enemy_threat += (global.city_owned_percent * 0.02);
	global.enemy_threat = min(100, global.enemy_threat); // Cap at 100% max
}


if (total_building_cash > 0) {
	audio_play_sound(snd_income, 1, false);
}

//reset the alarm to loop forever

alarm[0]= payout_rate;
