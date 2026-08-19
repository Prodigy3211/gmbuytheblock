// Room transition to game room

if(mouse_check_button_pressed(mb_left)){
	
	var scr_w = display_get_gui_width();
	var scr_h = display_get_gui_height();
	var cx = scr_w / 2;
	var cy = scr_h / 2;
	
	var btn_w = 200;
	var btn_h = 50;
	var btn_x1 = cx - (btn_w / 2);
	var btn_y1 = cy + 20;
	var btn_x2 = cx + (btn_w / 2);
	var btn_y2 = cy + 20 + btn_h;
	
	var gui_m_x = device_mouse_x_to_gui(0);
	var gui_m_y = device_mouse_y_to_gui(0);
	
	//Did mouse click land on button container?
	
	if (gui_m_x >= btn_x1 && gui_m_x <= btn_x2 && gui_m_y >= btn_y1 && gui_m_y <= btn_y2){
	
		//Play the purchase sound effect
		audio_play_sound(snd_buy, 10, false);
		
		//place room asset name for gameplay
		room_goto(Room1);
	}
}