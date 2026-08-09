//text alignment and size
draw_set_halign(fa_left);
draw_set_valign(fa_top);

//Draw a dark background box for readability

draw_set_colour(c_black);
draw_alpha= 0.5;
draw_rectangle(10,10,220,75,false); //Background big enough to have cash and progress bar

//Draw the cast text in green
draw_set_alpha(1.0);
draw_set_colour(c_lime);
draw_text_transformed(20,18,"Cash: $" + string(global.player_cash), hud_cash_scale,hud_cash_scale, 0);

// City Buyout Percentage Text
draw_set_colour(c_white);
draw_text(20, 48, "City Buyout: " + string(global.city_owned_percent) + "%");


//Draw out the Building Inspectional Panel if Building is Selected

if (global.selected_building != noone) {
	
	//create shortcuts for selected building's data
	var b_health = global.selected_building.building_health;
	var b_cost = global.selected_building.building_cost;
	var b_owned = global.selected_building.is_owned_by_player;
	
	//Set Box Dimension for Menu
	var ui_x1 = display_get_gui_width() - 320;
	var ui_y1 = display_get_gui_height() - 220;
	var ui_x2 = display_get_gui_width() - 20;
	var ui_y2 = display_get_gui_height() - 20;
	
	// Draw Panel Background box
	draw_set_colour(c_black);
	draw_set_alpha(0.85);
	draw_rectangle(ui_x1, ui_y1, ui_x2, ui_y2, false);
	
	//draw text info
	draw_set_alpha(1.0);
	draw_set_colour(c_white);
	draw_set_halign(fa_left);
	
	// Status text based on ownership
	var owner_text = b_owned ? "Owned By You" : "Owned by City";
	draw_text(ui_x1 + 20, ui_y1 + 20, "Status: " +owner_text);
	draw_text(ui_x1 + 20, ui_y1 + 50, "Price: $" +string(b_cost));
	draw_text(ui_x1 + 20, ui_y1 + 80, "Condition: " +string(ceil(b_health)) +" %");
	
	//Upgrade
	
	//Upgrade Level
	if(b_owned == true) {
		draw_set_colour(c_yellow);//The goal is to make this stand out
		draw_text(ui_x1 + 20, ui_y1 + 110, "Current Level: Tier " + string(global.selected_building.building_level));
		draw_set_colour(c_white); //reset text to write
	}
	
	//visual Health Bar
	var bar_x1 = ui_x1 + 20;
	var bar_y1 = ui_y1 + 140;
	var bar_x2 = ui_x2 - 20;
	var bar_y2 = ui_y2 + 155;
	
	draw_set_colour(c_dkgray)
	draw_rectangle(bar_x1, bar_y1, bar_x2, bar_y2, false); //Empty bar's background
	
	// color changes from green to red based on damage
	//want to add a visual indicator of damage as well.
	
	var health_color = (b_health > 40) ? c_green : c_red;
	draw_set_colour(health_color);
	
	//final width percent calculator. fill health bar calcs?
	
	var bar_fill = bar_x1 + ((bar_x2 -bar_x1) * (b_health / 100 ));
	draw_rectangle(bar_x1, bar_y1, bar_fill, bar_y2, false);
	
	//Render Action Buttons (repair/ Upgrade)
	var btn_w = 130;
	var btn_h = 30;
	var btn_left_x = ui_x1 + 20;
	var btn_right_x = ui_x1 + 170;
	var btn_y = ui_y1 + 150;
	
	//Button A (Buy or Upgrade)
	var can_afford = (global.player_cash >= global.selected_building.upgrade_cost);
	var is_maxed = (global.selected_building.building_level >= 5);
	
	
	if (b_owned == false){
	var can_buy = (global.player_cash >= global.selected_building.building_cost);
	draw_set_colour(can_buy ? c_gray : c_dkgray);
	
	
	draw_rectangle(btn_left_x, btn_y, btn_left_x + btn_w, btn_y + btn_h, false);
	draw_set_colour(c_white);
	draw_set_halign(fa_center);

	if(b_owned == true && (is_maxed || can_afford)) {
	
	draw_set_colour(c_dkgray);
	
} else {
		draw_set_colour(c_gray);
}
	}


	// the actual rectangle shape
	draw_rectangle(btn_left_x, btn_y, btn_left_x + btn_w, btn_y + btn_h, false);
	
	
	draw_set_colour(c_white);
	draw_set_halign(fa_center);
	
	if(b_owned == false) {
		draw_text(btn_left_x + (btn_w/2), btn_y + 5, "BUY");
	}else if (is_maxed) {
		draw_set_alpha(c_yellow)
		draw_text(btn_left_x + (btn_w/2), btn_y + 5, "MAX LEVEL");
	}else {
		//Need a rectangle for upgrade button
		draw_set_colour(c_gray);
		draw_rectangle(btn_right_x,btn_y,btn_right_x+btn_w, btn_y + btn_h, false)
		
		draw_set_colour(c_white);
		draw_text(btn_left_x + (btn_w/2), btn_y + 5, "UPGRADE ($" + string(global.selected_building.upgrade_cost)+ ")");
	}
	
	//Button B Repair button. only appears if player owned.
	if(b_owned == true) {
		//change color to bright gray if damaged, dark gray if already full
		draw_set_colour((b_health < 100) ? c_gray : c_dkgray);
		draw_rectangle(btn_right_x, btn_y, btn_right_x + btn_w, btn_y + btn_h, false)
		
		draw_set_colour(c_white);
		draw_text(btn_right_x + (btn_w/2), btn_y + 5, "REPAIR ($" +string(global.selected_building.repair_cost)+ ")");
	}	
	
	
	//beroom
//	boon_owned == fixile
	
	
	//How to close the panel
//	draw_set_colour(c_dkgray);
	//draw_text(ui_x1 + 20, ui_y1 + 160, "Press [esc] ti deselect");
}

//win/lose screen

//check if game is over
if(game_over_state != "playing") {
	//Draw a full screen semi trasnparent black overlay
	draw_set_colour(c_black);
	draw_set_alpha(0.85);
	draw_rectangle(0,0, display_get_gui_width(), display_get_gui_height(),false);
	
	//center the text
	draw_set_alpha(1.0);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	var screen_cx = display_get_gui_width() / 2;
	var screen_cy = display_get_gui_height() / 2;
	
	if(game_over_state == "win") {
		draw_set_colour(c_lime);
		draw_text(screen_cx, screen_cy - 20, "VICTORY!");
		draw_set_colour(c_white);
		draw_text(screen_cx, screen_cy + 20, "You successfully own this bitch!");
	} else if (game_over_state == "lose") {
		draw_set_colour(c_red);
		draw_text(screen_cx, screen_cy - 20, "You SUCK!");
		draw_set_colour(c_white);
		draw_text(screen_cx, screen_cy + 20, "The city has frozen your assets and reclaimed your property");
	}
}