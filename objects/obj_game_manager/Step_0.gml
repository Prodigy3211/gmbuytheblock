//Start up Instructions!
if (show_instructions == true) {
	//If player clicks the mouse, dismiss the guide
	if(mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) { 
			show_instructions = false;
		}
		
		//freeze all background operations so game doesn't start early
		exit;
}


//apply camera screen shake
if (shake_remain > 0){
	var camera = view_camera[0];
	var cam_x = camera_get_view_x(camera);
	var cam_y = camera_get_view_y(camera);
	
	//Add random offset based on current shake
	var rx = random_range(-shake_remain, shake_remain);
	var ry = random_range(-shake_remain, shake_remain);
	camera_set_view_pos(camera, cam_x + rx, cam_y = ry);
	
	//Decay the shake variables over time
	shake_remain = max(0, shake_remain - 0.5);
}


//smoothly animate HUD back to Scale 100%

hud_cash_scale = lerp(hud_cash_scale, 1.0, 0.1);


// Keyboard Map navigation

//Input keys
var move_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var move_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var move_up = keyboard_check(vk_up) || keyboard_check(ord("W"));
var move_down = keyboard_check(vk_down) || keyboard_check(ord("S"));

// Change Camera target position based on which keys are held
if (move_left) global.cam_x -= cam_speed;
if (move_right) global.cam_x += cam_speed;
if (move_up) global.cam_y -= cam_speed;
if (move_down) global.cam_y += cam_speed;

// Get the Screen size
//var view_w = camera_get_view_width(view_camera);
//var view_h = camera_get_view_height(view_camera);

// Apply Boundary
// Clamp (variable, minumum_allowed, max allowed)

global.cam_x = clamp(global.cam_x, 0, room_width - 1366);
global.cam_y = clamp(global.cam_y, 0, room_height - 768);

//Update the games active lens position with the clamp coordinates

camera_set_view_pos(view_camera[0], global.cam_x, global.cam_y)


//Button clicks only work when building is selected

if(global.selected_building == noone || !mouse_check_button_pressed(mb_left)) {
	
	exit;
}
	
	//UI Layout
	
	var ui_x1 = display_get_gui_width() - 320;
	var ui_y1 = display_get_gui_height() - 220;
	
	//mouse coordinates based on GUI layer
	var gui_mouse_x = device_mouse_x_to_gui(0);
	var gui_mouse_y = device_mouse_y_to_gui(0);
	
	//Automated boxes for buttons
	var btn_h = 24;
	var btn_y = ui_y1 + 158;
	var max_panel_w = 285;
	
	
	//Pointer to selected target variables
	var inst = global.selected_building;
	var district_data = variable_struct_get(global.districts, inst.building_district);
	var is_unlocked = district_data.unlocked;
	var b_owned = inst.is_owned_by_player;
	
	
	
	//New Unlock Button override
	
	if(is_unlocked == false) {
		
		//If sector is locked then player cannot buy/ upgrade / repair
		if(gui_mouse_x >= ui_x1 + 15 && gui_mouse_x <= ui_x1 + 15 + max_panel_w &&
		gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h){
			
			if (global.player_influence >= district_data.cost){
					global.player_influence -= district_data.cost;
					district_data.unlocked = true
					audio_play_sound(snd_unlock, 15, false);
			}
		}
		exit; // blocks other buttons below
	}
	
	
	//NEW BUTTON LOGIC
	
	if(b_owned == false){
		
		//Purchase button
		if(gui_mouse_x >= ui_x1 + 15 && gui_mouse_x <= ui_x1 + 15 + max_panel_w &&
			gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h) {
			
			if (global.player_cash >= inst.building_cost){
					global.player_cash -= inst.building_cost;
					inst.is_owned_by_player= true;
					inst.image_blend = inst.owned_building_color;
					
					var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
					txt.text = "-$" + string(inst.building_cost);
					txt.text_colour = c_red;
					audio_play_sound(snd_buy, 10, false);
			}	 
	  }
	  exit;
	}
	
	
// Tracking button constructor clicks

var actions_array = inst.building_actions;
var total_actions = array_length(actions_array);

var space_per_button =max_panel_w / total_actions;
var btn_w = space_per_button - 10;

for (var i = 0; i < total_actions; i ++){
	//Find the x coordinate
	var btn_x = (ui_x1 + 15) + (i * space_per_button);
	
	//Run Hitbox checks using inst
	if(actions_array[i].check_click(btn_x, btn_y, btn_w, btn_h, inst)){
		break;
	}
}







