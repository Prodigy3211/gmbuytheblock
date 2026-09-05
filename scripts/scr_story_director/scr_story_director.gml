//Pauses active systems and loads narrative overlay card

function trigger_story_event(_event_struct){
	global.story_active = true;
	global.active_story_struct = _event_struct;
	
	//safely capture the current threat check
	if(instance_exists(obj_game_manager)){
		global.saved_sabotage_time = max(1, obj_game_manager.alarm[2]);
		
		//Set threat clock to -1 to freeze the atack alarm
		obj_game_manager.alarm[2] = -1;
	}
	
}

//Monitor Mouse clicks
function story_director_update(){
	var display_w = display_get_gui_width();
	var display_h = display_get_gui_height();
	
	var card_h = 300;
	var cy2 = (display_h / 2) + (card_h / 2);
	
	var btn_y = cy2 -50;
	var btn_w = 200;
	var btn_h = 30;
	var bx1 = (display_w / 2) - (btn_w / 2);
	var bx2 = bx1 + btn_w;
	
	var gui_mouse_x = device_mouse_x_to_gui(0);
	var gui_mouse_y = device_mouse_y_to_gui(0);
	
	//Check if player clicks the "Aknowledge/continue" button
	if (gui_mouse_x >= bx1 && gui_mouse_x <= bx2 && gui_mouse_y >= btn_y && gui_mouse_y <= btn_y + btn_h){
		
		if(mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) {
			var current_event = global.active_story_struct;
			
			if(current_event != noone){
				//Trigger the threat spike and the story advance
				current_event.effect();
			}
			
			//Close the window
			global.story_active = false;
			global.active_story_struct = noone;
			
			//restore the threat clock
			if(instance_exists(obj_game_manager)){
				obj_game_manager.alarm[2] = global.saved_sabotage_time;
			}
			audio_play_sound(snd_unlock, 10, false); // confirmation
		}
	
	}
}