//Handles movement between choices and actions once buttons are clicked

//If they hit Escape, the game begins again
if(keyboard_check_pressed(vk_escape)){
	instance_activate_all(); // Brings the full simulation back to life
	instance_destroy(); //deletes the menu object
	exit;
}

//Manu Nav logic
var move_up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var move_down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var select_key = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

//Cycle between the 3 menu slots

if(move_up) pause_selected = (pause_selected - 1 + 3) % 3;
if(move_down) pause_selected = (pause_selected + 1) % 3;


//Execute selection!

if(select_key){
	switch(pause_selected){
	case 0: //Resume
		instance_activate_all();
		instance_destroy();
		break;
	case 1: //Restart
		instance_activate_all();
		
		//explicitly wipe all the eveonomy states
		global.player_cash = 1000;
		global.enemy_threat = 0;
		global.city_owned_percent = 0;
		global.selected_building = noone;
		global.player_influence =0;
		global.player_population = 0;
		global.player_population_max = 5;
		global.net_cash_tick = 0;
		global.net_influence_tick = 0;
		global.garrison_units= 0;
		global.story_phase = StoryPhase.Intro;
		global.story_active = false;
		global.active_story_struct = noone;
		global.story_unit_cost_multiplier = 1.0; //Normal cost of units
		global.triggered_homebase_siege = false;
		global.triggered_ownership_25 = false;
		global.triggered_final_lockdown = false;
		global.triggered_ownership_50 = false
		
		global.districts = {
			"West Side": { unlocked: true, cost: 0},
			"Downtown": { unlocked: false, cost: 175},
			"East Side": { unlocked: false, cost: 300},
			"Uptown": { unlocked: false, cost: 1000},
			"Capital Hill": { unlocked: false, cost: 2000},
		};
		
		global.game_tick =0;
		
		
		
		
		instance_destroy();
		room_goto(rm_title_screen);
		break;
		
	//case 2: //Quit
	//	instance_activate_all();
		
	//	//Clear all objects
	//	with(obj_building_parent) instance_destroy();
		
	
	
	}
}