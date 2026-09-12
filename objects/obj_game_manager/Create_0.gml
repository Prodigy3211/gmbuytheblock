global.game_tick = 0;
global.player_cash = 1000; // Used to buy units and buildings
global.player_population_max= 5; //Max Population
global.player_population = 0; //Total Population
global.player_influence = 0; //spent on policies
global.homebase_instance = noone; // Player base pointer
global.payout_check_rate = 300;
alarm[0] = global.payout_check_rate;

global.selected_building = noone; //ensures that no building is selected as default
global.city_owned_percent = 0;
global.net_cash_tick = 0;
global.net_influence_tick = 0;
global.garrison_units= 0; //Starting defenders

//camera tracking for mobile
global.drag_start_x = 0;
global.drag_start_y = 0;
global.drag_cam_start_x = 0;
global.drag_cam_start_y = 0;


//Nrrative State Tracker
enum StoryPhase {
	Intro,
	RisingThreat,
	UndergroundWar,
	EndGame
}


global.story_phase = StoryPhase.Intro;
global.story_active = false;
global.active_story_struct = noone;

//Controls when a Story event freezes the games
global.saved_sabotage_time = -1;
global.saved_economy_time = -1;


//triggers
global.story_unit_cost_multiplier = 1.0; //Normal cost of units

global.triggered_homebase_siege = false;
global.triggered_ownership_25 = false;
global.triggered_final_lockdown = false;
global.triggered_ownership_50 = false;


//Master Struct of All City Districts
global.districts = {
	"West Side": { unlocked: true, cost: 0, cash_cost: 0},
	"Downtown": { unlocked: false, cost: 175, cash_cost: 1000},
	"East Side": { unlocked: false, cost: 300, cash_cost: 1500},
	"Uptown": { unlocked: false, cost: 1000, cash_cost: 3500},
	"Capitol Hill": { unlocked: false, cost: 2000, cash_cost: 7500},
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


//Story beats!
global.story_database = {
	
	
	//Phase:CIA Drug Dispense(Triggered by 25% buy out)
	ownership_25:{
		title:"!!! OPEN DRUG MARKET !!!",
		text:"Reports indicate that strange black vans have appeared throughout our neighborhoods, Green Magic makes your day a little less stressful! We've got to do something about these drug dealers. -$750",
		effect: function(){
			global.player_cash -= 750; //Fee to clear out the gangs
			global.enemy_threat += 15; //The government doesn't like the violence
			global.story_phase = StoryPhase.UndergroundWar;
		}
	},
	
	//Phase 3: Underground war 50% ownership
	ownership_50:{
		title:"!!!WATER CONTAMINATION!!!",
		text: "Reports indicate that several of our buildings are unable to access clean water! It will cost a lot of resources to get things back to normal. Make sure you've repaired all effected buildings. -$2,000",
		effect: function(){
			global.player_cash -= 2000;
			global.story_phase = StoryPhase.EndGame;
		}
	},
	//Phase: Homebase attack
	homebase_siege:{
		title:"!!! BASE UNDER ATTACK !!!",
		text: "Dear Leader! They've hit our base! You've got to do something or we'll lose everything.",
		effect: function(){
			if(instance_exists(global.homebase_instance)){
				//Center camera on homebase
					global.cam_x = global.homebase_instance.x - (display_get_gui_width() / 2);
					global.cam_y = global.homebase_instance.y - (display_get_gui_height() / 2);
					building_shake(global.homebase_instance, 15, 60);
			}
			
			global.enemy_threat -= 70; // This should reduce the enemy threat a lot
		}
	
	
	},
	
	
	//Unlocking East Side
	east_side_unlocked: {
		title: "Stay Out Of The East (UNIT COST INCREASE)",
		text:"Although you haven't broken any laws, the residents of the east side, have petitioned the Mayor to stop your advance. Claiming that the East Side is Unionized and your faction threatens their economic opportunities",
		effect: function(){
			global.enemy_threat += 30;
			global.story_unit_cost_multiplier = 1.5;
			
		}
	},
	
	
	//Phase: Martial Law 80% owned
	martial_law:{
		title: "MARTIAL LAW DECLARED",
		text: "The Mayor has declared a state of emergency. The President of the United States is sending in the national guard. It's a race to the finish line. Hurry up and buy the rest of the city!",
		effect: function(){
			global.threat_check_rate = 400;
			global.story_phase = StoryPhase.EndGame;
		}
	}
	
};




//Payout timer (60 frames = 1 second at 60fps. 30 frames = 1secone at 30fps)

payout_rate = 300;
alarm[0] = payout_rate;


//random event every 45 seconds
alarm[1] = 2700;

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
global.threat_check_rate = 900; //Checks for a Raid every 15 seconds
alarm[2] = global.threat_check_rate; //Alarm 2 is now our enemy Director

//instructions

show_instructions = true; //When game starts display



