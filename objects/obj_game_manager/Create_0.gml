global.player_cash = 1000; // Used to buy units and buildings
global.player_population_max= 5; //Max Population
global.player_population = 0; //Total Population
global.player_influence = 0; //spent on policies
global.selected_building = noone; //ensures that no building is selected as default
global.city_owned_percent = 0;
global.net_cash_tick = 0;
global.net_influence_tick = 0;
global.garrison_units= 0; //Starting defenders





//Master Struct of All City Districts
global.districts = {
	"West Side": { unlocked: true, cost: 0},
	"Downtown": { unlocked: false, cost: 175},
	"East Side": { unlocked: false, cost: 300},
	"Uptown": { unlocked: false, cost: 1000},
	"Capital Hill": { unlocked: false, cost: 2000},
};
//global.district_uptown_unlocked = false;
//global.district_uptown_unlock_cost = 50 // costs 50 influence to unlock Uptown
//global.district_eastside_unlocked = false;
//global.district_eastside_unlock_cost = 300;

//Master Struct for All Units
global.faction_units = {
	recruiter:{
		count: 0,
		cash_cost: 250,
		pop_cost: 1
	},
	defender:{
		count: 0,
		cash_cost: 300,
		pop_cost: 1
	},
	spy:{
		count: 0,
		cash_cost: 1000,
		pop_cost: 2
	},
	bookie:{
		count: 0,
		cash_cost: 600,
		pop_cost: 1
	}
};



//Payout timer (60 frames = 1 second at 60fps. 30 frames = 1secone at 30fps)

payout_rate = 180;
alarm[0] = payout_rate;


//random event every 10 seconds
alarm[1] = 600;

//Win or Lose
game_over_state = "playing"; //can switch to win or lose

//screen shake when building purchase
shake_magnitude = 0;
shake_remain = 0;

hud_cash_scale = 1.0;

//Coordinate tracking for top left corner
global.cam_x = 0;
global.cam_y = 0;

//Panning Travel Speed
cam_speed = 8;

//display_set_gui_size(1366, 768);

//Lens settings to fix resolution
//view_enabled = true;
//view_visible[0] = true;

//Standard Camera Build
//var view_cam = camera_create_view(0, 0, 1366, 768, 0, noone, -1, -1, -1, -1);
//view_set_camera(0, view_cam);

//GUI Match layer size with Viewport
display_set_gui_size(window_get_width(),window_get_height());

//reset camera tracking
global.cam_x = 0;
global.cam_y = 0;
cam_speed = 10;


//Enemy Threat Level!

global.enemy_threat = 0;
global.threat_check_rate = 600; //Checks for a Raid every 10 seconds
alarm[2] = global.threat_check_rate; //Alarm 2 is now our enemy Director

//instructions

show_instructions = true; //When game starts display



//HANDLES BUYING ALL UNITS

purchase_faction_unit = function (_unit_key){
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
		unit_data.current_cash_cost = ceil(current_cash_cost * 1.4);
		
		//floating text confirmation over selected building
		var inst = global.selected_building;
		if(inst != noone) {
			var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
			txt.text = "-$" + string(current_cash_cost) + " " + string_upper(_unit_key);
			txt.text_color = c_red;
		}
		//Purchase building sound effect
		audio_play_sound(snd_buy, 10, false);
		return true; //Transaction complete!
	}
	
	//DEBUG IF TRANSACTION FAILS
	if(!has_enough_room){
		show_debug_message("FAILED: population cap hit! Buy more housing");
	}
	
	return false; //Transaction blocked!

}

