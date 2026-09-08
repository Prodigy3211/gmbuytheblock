//Protection from clicking buildings beneath "Buy" or Other UI
var gui_mx = device_mouse_x_to_gui(0);
var gui_my = device_mouse_y_to_gui(0);

//check if building is selected and mouse is over the inspection panel
if (global.selected_building != noone) {
	var ui_x1 = display_get_gui_width() - 320;
	var ui_y1 = display_get_gui_height() - 220;
	if(gui_mx >= ui_x1 && gui_my >= ui_y1)exit;
	
}

//blocks the clicks in resource tracking panel
if(gui_mx >= 10 && gui_mx <= 320 && gui_my >= 10 && gui_my <= 135) {
	exit;
}



//Click a building for Global UI window
global.selected_building = id;
show_debug_message("Selected building ID: "+ string(id));


//Old test logic delete if it works later

//if(is_owned_by_player == false){
//	if(global.player_cash >= building_cost){
		//deduct cash from player's bank account
//		global.player_cash-= building_cost;
//		is_owned_by_player = true;
	
	//Turn building green for owned
//		switch(object_index){
//			case (obj_residence):
//				image_blend= c_green;
//				break;
//			case(obj_commercial):
//				image_blend= c_teal;
//				break;
//			case(obj_factory):
//				image_blend= c_yellow;
//				break;
//		}
		
		
//		show_debug_message("Building Purchased! Remaining cash: " + string(global.player_cash));
		
//	} else {
//		show_debug_message("You're too broke! Costs: " + string(building_cost));
//	}
	
//}