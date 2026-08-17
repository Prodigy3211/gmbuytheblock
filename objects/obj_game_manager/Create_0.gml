global.player_cash = 1000; // Used to buy units and buildings
global.player_population_max= 5; //Max Population
global.player_population = 0; //Total Population
global.player_influence = 0; //spent on policies
global.selected_building = noone; //ensures that no building is selected as default
global.city_owned_percent = 0;
global.net_cash_tick = 0;
global.net_influence_tick = 0;




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
view_enabled = true;
view_visible[0] = true;

//Standard Camera Build
var view_cam = camera_create_view(0, 0, 1366, 768, 0, noone, -1, -1, -1, -1);
view_set_camera(0, view_cam);

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