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
			if (inst.is_owned_by_player == false) {
				//Buy Logic
				if(global.player_cash >= inst.building_cost) {
					global.player_cash -= inst.building_cost;
					inst.is_owned_by_player = true;
					inst.image_blend = inst.owned_building_color;
					
					//Shake effect for building purchase
					inst.image_xscale = 1.3; //snap to 130% of size
					inst.image_yscale = 1.3;
					
					//4-pixel screen sshake
					shake_magnitude = 4
					shake_remain = 4
				}
			} else {
				//Upgrade Button
				if(global.player_cash >= inst.upgrade_cost){
					global.player_cash -= inst.upgrade_cost;
					inst.building_level += 1;
					inst.income_amount = ceil(inst.upgrade_cost * 1.8);
				
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