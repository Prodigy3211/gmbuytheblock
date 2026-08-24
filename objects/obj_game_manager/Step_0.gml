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
	
	//Boxes bound to buttons
	var btn_w = 85; //Narrower buttons to fit new button slot
	var btn_h = 24;
	
	var btn_left_x = ui_x1 + 15;
	var btn_center_x = ui_x1 + 115; //New Repair slot in the center
	var btn_right_x = ui_x1 + 215;
	var btn_y = ui_y1 + 158;
	
	//Wide layout for normal buildings
	var b_wide_w = 130;
	var b_wide_right_x = ui_x1 + 170;
	
	//Pointer to selected target variables
	var inst = global.selected_building;
	var district_data = variable_struct_get(global.districts, inst.building_district);
	var is_unlocked = district_data.unlocked;
	
	// State Detection for buildings
	var is_base = inst.is_player_base;
	var current_btn_w = is_base ? btn_w : b_wide_w;
	var current_right_x = is_base ? btn_right_x : b_wide_right_x;
	
	
	//New Unlock Button override
	
	if(is_unlocked == false) {
		
		//If sector is locked then player cannot buy/ upgrade / repair
		if(gui_mouse_x >= btn_left_x && gui_mouse_x <= btn_left_x + current_btn_w &&
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
	
	if(inst.is_player_base == true){
		
		//Left Button Slot
		if(gui_mouse_x >= btn_left_x && gui_mouse_x <= btn_left_x + btn_w &&
			gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h) {
			
			purchase_faction_unit("recruiter");
			exit;
			}
			
		// Center Slot
		 if(gui_mouse_x >= btn_center_x && gui_mouse_x <= btn_center_x + btn_w &&
			gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h) {
			
			if (inst.building_health < 100 && global.player_cash >= inst.repair_cost){
				global.player_cash -= inst.repair_cost;
				inst.building_health = 100;
				
				var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
				txt.text ="-$" + string(inst.repair_cost) + " Repair";
				txt.text_color = c_red;
				audio_play_sound(snd_unlock, 10, false);
			}
			exit;
			
			}
			
			//Right slot
			if(gui_mouse_x >= btn_right_x && gui_mouse_x <= btn_right_x + btn_w &&
			gui_mouse_y >= btn_y && gui_mouse_y <= btn_y +btn_h){
			
			purchase_faction_unit("defender");
			exit;
		}
	} else {
	  // REGULAR BUILDING BUTTON LOGIC
	  
	  //Left slot (Buy/Upgrade: WIDE POSITION)
	  if(gui_mouse_x >= btn_left_x && gui_mouse_x <= btn_left_x + b_wide_w &&
			gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h){
			
			if(inst.is_owned_by_player == false){
				//Buy with cash
				if(global.player_cash >= inst.building_cost){
					global.player_cash -= inst.building_cost;
					inst.is_owned_by_player = true;
					inst.image_blend = inst.owned_building_color;
					
					var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
					txt.text = "-$" + string(inst.building_cost);
					txt.text_color = c_red;
					audio_play_sound(snd_buy, 10, false);
				}
			} else {
				//Basic building upgrades
				if(inst.building_level < 5 && global.player_cash >= inst.upgrade_cost){
					
					global.player_cash -= inst.upgrade_cost;
					inst.building_level += 1;
					inst.income_amount += 20;
					
					//Add Floating confirmation text
					var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
					txt.text = "-$" + string(inst.upgrade_cost);
					txt.text_color = c_red;
					audio_play_sound(snd_upgrade, 10, false);
					
					
					//Scale up Upgrade cost
					inst.upgrade_cost = inst.upgrade_cost * 2;
				} 
			}
		exit;
	} 
	
	
	//Right button Wide Version
	
	if(gui_mouse_x >= current_right_x && gui_mouse_x <= current_right_x + current_btn_w &&
       gui_mouse_y >= btn_y && gui_mouse_y <= btn_y +btn_h){
		
		if(inst.is_owned_by_player == true && inst.building_health < 100){
			if(global.player_cash >= inst.repair_cost){
				global.player_cash -= inst.repair_cost;
				inst.building_health = 100;
				
				//Add Floating confirmation text
					var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
					txt.text = "-$" + string(inst.repair_cost);
					txt.text_color = c_red;
					audio_play_sound(snd_unlock, 10, false);
				
			}
			
		}
		exit;
	  }
	}
	
	
	//OLD BUTTON LOGIC
	
	//Click Detection: Primary Action Button (buy or upgrade building)
	//if (gui_mouse_x >= btn_left_x && gui_mouse_x <= btn_left_x + btn_w &&
	//	gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h) {
			
	//		//Sector Influence transaction here
	//		if (district_data.unlocked == false) {
	//			if(global.player_influence >= district_data.cost){
	//			//Deduct influence points
	//			global.player_influence -= district_data.cost;
	//			district_data.unlocked = true;
				
	//			audio_play_sound(snd_unlock, 15, false);
				
	//			//Trigger a visual confirmation popup over the building
	//			var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
	//			txt.text = inst.building_district + "Unlocked!";
	//			txt.text_color = c_lime;
	//		}
	//		exit;
				
	//	}	
			
	//		if(inst.is_player_base == true) {
				
	//			//Check for Population Capacity before user can buy Recruiters at the home base
	//			if (global.player_cash >= inst.recruiter_cost && global.player_population < global.player_population_max) {
					
	//				global.player_cash -= inst.recruiter_cost;
	//				inst.recruiter_count += 1;
					
	//				//Add to current population
	//				global.player_population += 1;
	//				inst.recruiter_cost = ceil(inst.recruiter_cost * 1.4);
					
	//				audio_play_sound(snd_recruit, 15, false);
					
	//				var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
	//				txt.text = "-$" +string(inst.recruiter_cost);
	//				txt.text_color= c_red;
	//			} else if (global.player_population >= global.player_population_max){
	//				show_debug_message("Population Cap REACH! Buy Residences to grow.");
	//			}
	//			exit;
	//		}
			
	//		if (inst.is_owned_by_player == false) {
	//			//Buy Logic
	//			if(global.player_cash >= inst.building_cost) {
	//				global.player_cash -= inst.building_cost;
	//				inst.is_owned_by_player = true;
					
	//				//Sound effect for buying
	//				audio_play_sound(snd_buy, 10, false);
					
					
	//				var current_base_x = variable_instance_exists(inst,"base_width_scale") ? inst.base_width_scale : inst.image_xscale;
	//				var current_base_y = variable_instance_exists( inst, "base_height_scale") ? inst.base_height_scale : inst.image_yscale;
					
	//				inst.image_blend = inst.owned_building_color;
					
	//				//floating Deduction test on top of Building
	//				var txt = instance_create_layer(inst.x, inst.y - 20, "Instances", obj_floating_text);
	//				txt.text = "-$" + string(inst.building_cost);
	//				txt.text_color = c_red; //Red for Spending that Cash!
					
	//				//Snap the HUD text to 150% for animation of deduction
	//				hud_cash_scale = 1.5;
					
					
	//				//Shake effect for building purchase
	//				inst.target_scale_x = inst.base_width_scale * 1.3; //snap to 130% of size
	//				inst.target_scale_y= inst.base_height_scale * 1.3;
					
	//				//4-pixel screen sshake
	//				shake_magnitude = 4
	//				shake_remain = 4
					
	//				inst.target_scale_x = current_base_x * 1.3;
	//				inst.target_scale_y = current_base_y * 1.3;
	//				inst.image_xscale = current_base_x *1.3;
	//				inst.image_yscale = current_base_y * 1.3;
	//			}
	//		} else {
	//			//Upgrade Button
	//			if(inst.building_level < 5 && global.player_cash >= inst.upgrade_cost){
	//				global.player_cash -= inst.upgrade_cost;
	//				inst.building_level += 1;
					
	//				inst.income_amount += 20;
	//				inst.upgrade_cost = inst.upgrade_cost * 2;
					
	//				audio_play_sound(snd_upgrade, 15, false);
					
	//				var current_base_x = variable_instance_exists(inst,"base_width_scale") ? inst.base_width_scale : inst.image_xscale;
	//				var current_base_y = variable_instance_exists( inst, "base_height_scale") ? inst.base_height_scale : inst.image_yscale;
					
	//				inst.target_scale_x = current_base_x * 1.3;
	//				inst.target_scale_y = current_base_y * 1.3;
	//				inst.image_xscale = current_base_x *1.3;
	//				inst.image_yscale = current_base_y * 1.3;
					
	//				//Made the player get money too fast
	//				//inst.income_amount = ceil(inst.upgrade_cost * 1.5);
	//				//inst.upgrade_cost = ceil(inst.upgrade_cost * 1.8);
				
	//			}
	//		}
	//	}
		
		
	//	//Click Detection : Repair button
	//	if(gui_mouse_x >= btn_right_x && gui_mouse_x <= btn_right_x + btn_w &&
	//		gui_mouse_y >= btn_y && gui_mouse_y <= btn_y +btn_h) {
				
	//			if(inst.is_player_base == true) {
	//				if (inst.building_health < 100){
	//				//Base repair / hire defender
	//				//If base is damaged then you must repair before you can hire a defender
	//				if (global.player_cash >= inst.repair_cost){
	//					global.player_cash -= inst.repair_cost;
	//					inst.building_health = 100; //Bring HQ to full health
						
	//					audio_play_sound(snd_unlock, 15, false);
						
	//					var txt = instance_create_layer(inst.x, inst.y -20, "Instances", obj_floating_text);
	//					txt.text = "-$" + string(inst.repair_cost) + " Repair";
	//					txt.text_color = c_red;
	//				}
	//			} else {
	//				//Base is at 100% health so now you can recruite defenders
	//				var defender_cash_cost = 300; //If you change this value you must change it in Draw GUI as well
	//				if(global.player_cash >= defender_cash_cost && global.player_population < global.player_population_max) {
	//					global.player_cash -= defender_cash_cost;
	//					global.garrison_units += 1;
	//					global.player_population += 1;
						
	//					audio_play_sound(snd_defender,15,false);
						
	//					var txt = instance_create_layer(inst.x, inst.y -20, "Instances", obj_floating_text);
	//					txt.text = "-$300 Def";
	//					txt.text_color = c_red;
	//				} else if (global.player_population >= global.player_population_max) {
	//					show_debug_message("Population Cap Reached! Cannot recruit any more defenders");
	//				}
	//			}
			
	//			exit; // Prevent the button from processing repairs and defenders at the same time
				
	//	} else {
				
	//			if (inst.is_owned_by_player == true && inst.building_health < 100) {
	//				if(global.player_cash >= inst.repair_cost) {
	//					global.player_cash -= inst.repair_cost;
	//					inst.building_health = 100; //restore to full
	//					audio_play_sound(snd_unlock, 15, false);
	//				}
	//			}
	//			exit;
	//		}
	//		}



