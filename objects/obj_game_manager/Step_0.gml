global.game_tick +=1;


//Start up Instructions!
if (show_instructions == true) {
	//If player clicks the mouse, dismiss the guide
	if(mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) { 
			show_instructions = false;
		}
		
		//freeze all background operations so game doesn't start early
		exit;
}

if(global.story_active == true){
	story_director_update();
	exit;
}


//Mobile Phone touch screen
if(device_mouse_check_button_pressed(0, mb_left)) {
	//Store starting position of the drag
	global.drag_start_x = window_mouse_get_x();
	global.drag_start_y = window_mouse_get_y();
	global.drag_cam_start_x = global.cam_x;
	global.drag_cam_start_y = global.cam_y;
}

//check if they are hoding down and dragging finger
if(device_mouse_check_button(0, mb_left)){
	//exit if they are clicking a menu item
	if(global.story_active == true) return;
	
	//Calculate where the finger has moved from start
	var current_touch_x = window_mouse_get_x();
	var current_touch_y = window_mouse_get_y();
	
	var distance_dragged_x = current_touch_x - global.drag_start_x;
	var distance_dragged_y = current_touch_y - global.drag_start_y;
	
	//change camera based on finger direction (for natural feelings)
	global.cam_x = global.drag_cam_start_x - distance_dragged_x;
	global.cam_y = global.drag_cam_start_y - distance_dragged_y;
}


// Keyboard Map navigation

//Move speed
var base_speed = 12;
var scroll_speed_x = base_speed * 1.8; //for wide frame axis
var scroll_speed_y = base_speed;

//Input keys
var move_left = keyboard_check(vk_left) || keyboard_check(ord("A")); 
var move_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var move_up = keyboard_check(vk_up) || keyboard_check(ord("W"));
var move_down = keyboard_check(vk_down) || keyboard_check(ord("S"));

// Change Camera target position based on which keys are held
if (move_left) global.cam_x -= scroll_speed_x;
if (move_right) global.cam_x += scroll_speed_x;
if (move_up) global.cam_y -= scroll_speed_y;
if (move_down) global.cam_y += scroll_speed_y;

var max_scroll_x = max(0, room_width - 1366);
var max_scroll_y = max(0, room_height - 768);

// Get the Screen size
//var view_w = camera_get_view_width(view_camera);
//var view_h = camera_get_view_height(view_camera);

// Apply Boundary
// Clamp (variable, minumum_allowed, max allowed)

global.cam_x = clamp(global.cam_x, 0, max_scroll_x);
global.cam_y = clamp(global.cam_y, 0, max_scroll_y);



//Update the games active lens position with the clamp coordinates

camera_set_view_pos(view_camera[0], global.cam_x, global.cam_y)


//smoothly animate HUD back to Scale 100%

//hud_cash_scale = lerp(hud_cash_scale, 1.0, 0.1);


//Button clicks only work when building is selected

if(global.selected_building == noone) {
	
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
			
			
			//Check for clicks
			if(mouse_check_button_pressed(mb_left)){
				//SCRIPT CALL: Verify wallet authority to make purchase
				
			
			if (component_can_afford_district_unlock(inst.building_district)){
					var direct_cost = component_get_district_unlock_cost(inst.building_district);
					var cash_cost = component_get_district_unlock_cash_cost(inst.building_district);
				
					global.player_influence -= direct_cost;
					global.player_cash -= cash_cost;
					
					district_data.unlocked = true
					if(inst.building_district == "East Side"){
						trigger_story_event(global.story_database.east_side_unlocked);
					}
					
					audio_play_sound(snd_unlock, 15, false);
					
					var txt = instance_create_layer(inst.x, inst.y - 40, "Instances", obj_floating_text);
					txt.text = string_upper(inst.building_district) + " UNLOCKED!";
					txt.text_color = c_purple;
			} else {
				//Rejection feedback
				show_debug_message("Not enough influence!");
			
			}
		}
	}	
		exit; // blocks other buttons below
	}
	
	
	//NEW BUTTON LOGIC
	
	if(b_owned == false){
		
		//Purchase button
		if(gui_mouse_x >= ui_x1 + 15 && gui_mouse_x <= ui_x1 + 15 + max_panel_w &&
			gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h) {
			
			if(mouse_check_button_pressed(mb_left)) {
				//Script call for purchase multiplier
				var local_purchase_price = component_calculate_building_purchase_cost(inst.building_cost, inst.building_district);
				
				if (global.player_cash >= local_purchase_price){
						global.player_cash -= local_purchase_price;
						inst.is_owned_by_player= true;
						
						//force alarm 0 to check amount of buildings
						if(instance_exists(obj_game_manager)){
							with(obj_game_manager){
								event_perform(ev_alarm, 0);
							}
						}
						inst.image_blend = inst.owned_building_color;
						
						//Building shake
						building_shake(inst,3,12);
					
					var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
					txt.text = "-$" + string(local_purchase_price);
					txt.text_color = c_red;
					audio_play_sound(snd_buy, 10, false);
					
					//First narrative moment
					if(global.story_phase == StoryPhase.Intro){
						//Use a Struct to create the event
						var fist_contact_event = {
							title: "!!MESSAGE FROM THE MAYOR!!",
							text: "Attention Citizen: My Office has taken notice of your recent purchases on the west side. I'm not sure how you got the money to do this, but it all looks legal... for now. Your assets Have been logged. The city will reclaim any building that you don't maintain.",
							effect: function(){
								//Immediate gameplay Consequence
								global.enemy_threat += 25;
								//Advance the Story
								global.story_phase =StoryPhase.RisingThreat;
							}
						};
						
						trigger_story_event(fist_contact_event);
					}
			} else {
				//Rejection Feed back
				show_debug_message("You can't afford this brokie!");
			}
		}
	}
	  exit;
}


if (inst.is_player_base == true) {
	inst.building_actions = (inst.current_ui_page == 1) ? inst.building_actions_p1 : inst.building_actions_p2;
}	
	
// Tracking button constructor clicks

var actions_array = inst.building_actions;
var total_actions = array_length(actions_array);

var space_per_button =max_panel_w / total_actions;
var btn_w = space_per_button - 10;


if(mouse_check_button_pressed(mb_left)) {
	for (var i = 0; i < total_actions; i ++){
		//Find the x coordinate
		var btn_x = (ui_x1 + 15) + (i * space_per_button);
	
		//Run Hitbox checks using inst
		if(actions_array[i].check_click(btn_x, btn_y, btn_w, btn_h, inst)){
			break;
		}
	}

}


story_director_tick();
story_director_update();







