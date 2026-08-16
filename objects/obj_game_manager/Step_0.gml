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


//Button clicks only work when building is selected

if(global.selected_building != noone && mouse_check_button_pressed(mb_left)) {
	
	//UI Layout
	
	var ui_x1 = display_get_gui_width() - 320;
	var ui_y1 = display_get_gui_height() - 220;
	
	//mouse coordinates based on GUI layer
	var gui_mouse_x = device_mouse_x_to_gui(0);
	var gui_mouse_y = device_mouse_y_to_gui(0);
	
	//Boxes bound to buttons
	var btn_w = 130;
	var btn_h =30;
	
	var btn_left_x = ui_x1 + 20;
	var btn_right_x = ui_x1 + 170;
	var btn_y = ui_y1 + 150;
	
	//Pointer to selected target variables
	var inst = global.selected_building;
	
	//Click Detection: Primary Action Button (buy or upgrade building)
	if (gui_mouse_x >= btn_left_x && gui_mouse_x <= btn_left_x + btn_w &&
		gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h) {
			
			//Sector Influence transaction here
			if (inst.building_district == "Uptown" && global.district_uptown_unlocked == false) {
				if(global.player_influence >= global.district_uptown_unlock_cost){
				//Deduct influence points
				global.player_influence -= global.district_uptown_unlock_cost;
				global.district_uptown_unlocked = true;
				
				//Trigger a visual confirmation popup over the building
				var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
				txt.text = "District Unlocked!";
				txt.text_color = c_lime;
			}
			exit;
		}	
			
			if(inst.is_player_base = true) {
				//Check for Population Capacity before user can buy Recruiters at the home base
				if (global.player_cash >= inst.recruiter_cost && global.player_population < global.player_population_max) {
					
					global.player_cash -= inst.recruiter_cost;
					inst.recruiter_count += 1;
					
					//Add to current population
					global.player_population += 1;
					inst.recruiter_cost = ceil(inst.recruiter_cost * 1.4);
					
					var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
					txt.text = "-$" +string(inst.recruiter_cost);
					txt.text_color= c_red;
				} else if (global.player_population >= global.player_population_max){
					show_debug_message("Population Cap REACH! Buy Residences to grow.");
				}
				exit;
			}
			
			if (inst.is_owned_by_player == false) {
				//Buy Logic
				if(global.player_cash >= inst.building_cost) {
					global.player_cash -= inst.building_cost;
					inst.is_owned_by_player = true;
					inst.image_blend = inst.owned_building_color;
					
					//floating Deduction test on top of Building
					var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
					txt.text = "-$" + string(inst.building_cost);
					txt.text_color = c_red; //Red for Spending that Cash!
					
					//Snap the HUD text to 150% for animation of deduction
					hud_cash_scale = 1.5;
					
					
					//Shake effect for building purchase
					inst.image_xscale = 1.3; //snap to 130% of size
					inst.image_yscale = 1.3;
					
					//4-pixel screen sshake
					shake_magnitude = 4
					shake_remain = 4
				}
			} else {
				//Upgrade Button
				if(inst.building_level < 5 && global.player_cash >= inst.upgrade_cost){
					global.player_cash -= inst.upgrade_cost;
					inst.building_level += 1;
					
					inst.income_amount += 20;
					inst.upgrade_cost = inst.upgrade_cost * 2;
					
					//Made the player get money too fast
					//inst.income_amount = ceil(inst.upgrade_cost * 1.5);
					//inst.upgrade_cost = ceil(inst.upgrade_cost * 1.8);
				
				}
			}
		}
		
		
		//Click Detection : Repair button
		if(gui_mouse_x >= btn_right_x && gui_mouse_x <= btn_right_x + btn_w &&
			gui_mouse_y >= btn_y && gui_mouse_y <= btn_y +btn_h) {
				
				
				if (inst.is_owned_by_player == true && inst.building_health < 100) {
					if(global.player_cash >= inst.repair_cost) {
						global.player_cash -= inst.repair_cost;
						inst.building_health = 100; //restore to full
					}
				}
			}
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
