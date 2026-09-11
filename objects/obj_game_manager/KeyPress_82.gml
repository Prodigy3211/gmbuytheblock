//Allow restart after game win or lose

if(game_over_state == "win" || game_over_state = "lose"){
	global.player_cash = 1000;
	global.selected_building = noone;
	global.enemy_threat = 0;
	global.player_influence = 0;
	global.player_population = 0;
	global.garrison_units = 0;
	global.cam_x =0;
	global.cam_y = 0;
	show_instructions = true;
	global.player_population_max = 5;
	game_over_state = "playing";
	global.story_phase = StoryPhase.Intro;
	global.story_active = false;
	global.active_story_struct = noone;
	global.story_unit_cost_multiplier = 1.0;
	
	global.triggered_homebase_siege = false;
	global.triggered_ownership_25 = false;
	global.triggered_final_lockdown = false;
	global.triggered_ownership_50 = false;
	
	global.net_cash_tick = 0;
	global.net_influence_tick = 0;
	
	global.game_tick = 0;
	
	//Reset Sectors
	global.districts = {
	"West Side": { unlocked: true, cost: 0},
	"Downtown": { unlocked: false, cost: 175},
	"East Side": { unlocked: false, cost: 300},
	"Uptown": { unlocked: false, cost: 1000},
	"Capital Hill": { unlocked: false, cost: 2000},
};
	
	room_restart();
}