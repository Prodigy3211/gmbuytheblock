////Draw out the Building Inspectional Panel if Building is Selected
 
// if (global.selected_building != noone) {
	
	
	
//	//create shortcuts for selected building's data
//	var inst = global.selected_building;
//	var b_health = global.selected_building.building_health;
//	var b_cost = global.selected_building.building_cost;
//	var b_owned = global.selected_building.is_owned_by_player;
	
//	var can_afford_repair = (global.player_cash >= global.selected_building.repair_cost);
//	var can_repair = (global.player_cash >= global.selected_building.repair_cost && b_health < 100);
//	var can_upgrade = (global.player_cash >= global.selected_building.upgrade_cost);
	
//	var is_maxed = (global.selected_building.building_level >= 5);
//	var is_base = global.selected_building.is_player_base;
	
//	var district_data = variable_struct_get(global.districts, inst.building_district);
//	var is_unlocked = district_data.unlocked;
//	var unlock_cost = district_data.cost;
	
//	var recruiter_data = global.faction_units.recruiter;
//	var defender_data = global.faction_units.defender;
	
	
//	//Connecting Panel to buildings
//	var panel_w = 240;
//	var panel_h = (is_base) ? 245 : 185;
	
//	//Set Box Dimension for Menu
//	var ui_x1 = inst.x - (panel_w / 2);
//	var ui_y1 = inst.y - panel_h - 16;
//	var ui_x2 = ui_x1 + panel_w;
//	var ui_y2 = ui_y1 + panel_h;
	
//	// Draw Panel Background box
//	draw_set_colour(c_black);
//	draw_set_alpha(0.90);
//	draw_rectangle(ui_x1, ui_y1, ui_x2, ui_y2, false);
	
//	//outlining highlight border for polish
//	draw_set_colour(c_dkgray);
//	draw_set_alpha(1.0);
//	draw_rectangle(ui_x1, ui_y1, ui_x2, ui_y2, true);
	
//	//draw text info
//	//draw_set_alpha(1.0);
//	draw_set_colour(c_white);
//	draw_set_halign(fa_left);
	
//	// Status text based on ownership
//	var owner_text = b_owned ? "Owned By You" : "Owned by City";
//	draw_text(ui_x1 + 15, ui_y1 + 15, "Status: " + owner_text);
//	//draw_text(ui_x1 + 20, ui_y1 + 40, "Price: $" +string(b_cost));
//	draw_text(ui_x1 + 15, ui_y1 + 35, "Condition: " +string(ceil(b_health)) +" %");
	
//	//Upgrade
	
//	//Upgrade Level
//	if(b_owned == true) {
//		draw_set_colour(c_yellow);//The goal is to make this stand out
//		draw_text(ui_x1 + 15, ui_y1 + 55, "Current Level: Tier " + string(inst.building_level));
//		draw_set_colour(c_white); //reset text to white
//	}
	
//	if (is_base == true) {
//		draw_set_colour(c_orange);
//		draw_text(ui_x1 + 15, ui_y1 + 75, "Recruiters: " + string(inst.recruiter_count));		
//		//Faction Army count
//		draw_text(ui_x1 + 120, ui_y1 + 75, "Defenders: " + string(global.garrison_units));
//		draw_set_colour(c_white);
//	}
	
//	//visual Health Bar (shifted up to avoid blocking buttons)
//	var bar_x1 = ui_x1 + 15;
//	var bar_y1 = ui_y1 + 105;
//	var bar_x2 = ui_x2 - 15;
//	var bar_y2 = ui_y1 + 115;
	
//	draw_set_colour(c_dkgray)
//	draw_rectangle(bar_x1, bar_y1, bar_x2, bar_y2, false); //Empty bar's background
	
//	// color changes from green to red based on damage
//	//want to add a visual indicator of damage as well.
	
//	var health_color = (b_health > 40) ? c_green : c_red;
//	draw_set_colour(health_color);
	
//	//final width percent calculator. fill health bar calcs?
	
//	var bar_fill = bar_x1 + ((bar_x2 -bar_x1) * (b_health / 100 ));
//	draw_rectangle(bar_x1, bar_y1, bar_fill, bar_y2, false);
	
//	//BUTTON LAYOUT
	
//	var btn_y = ui_y1 + 130;
//	var btn_h = 24;
//	var max_panel_w = panel_w - 30;
	
//	//We are next the buy buttons inside of a new Sector Unlock section
	
//	if(is_unlocked == false){
//		//Fetch how much money it costs to unlock
//		var cash_unlock_cost = component_get_district_unlock_cash_cost(inst.building_district);
		
//		//Check if you can afford with Influence
//		var can_afford_unlock = (global.player_influence >= unlock_cost && global.player_cash >= cash_unlock_cost);
	
//	//Draw the unlock box
//	draw_set_colour(can_afford_unlock ? c_gray : c_dkgray);
//	draw_rectangle(ui_x1 + 15, btn_y, ui_x1 + 15 + max_panel_w, btn_y +btn_h, false);
	
//	//Draw the label for Unlock
//	draw_set_colour(c_white);
//	draw_set_halign(fa_center);
//	draw_set_valign(fa_middle)
//	draw_text(ui_x1 + 15 + (max_panel_w/ 2), btn_y + (btn_h /2), "UNLOCK DISTRICT");
	
//	//Print the cost notification in purple on the side
//	draw_set_valign(fa_top);
//	draw_set_halign(fa_left)
//	draw_set_colour(c_purple);
//	draw_set_halign(fa_left);
//	draw_text(ui_x1 + 15, ui_y1 + 165, inst.building_district + " Cost: " + string(unlock_cost) + " Infl.");
	
//	//display cash cost
//	draw_set_colour(c_lime);
//	draw_text(ui_x1 + 15, ui_y1 + 185, "& Requires: $" + string(cash_unlock_cost) + " Cash");
	
//	draw_set_colour(c_white);
	
//	} else if (!b_owned) {
//	//Button A (Buy or Upgrade) Left Button Slot 'Buy, Hire,Max Leve, Upgrade'	
	
//		var local_b_cost = component_calculate_building_purchase_cost(b_cost, inst.building_district);
	
//		//BUY BUTTON
//		var can_buy = (global.player_cash >= local_b_cost);
//		draw_set_colour(can_buy ? c_gray : c_dkgray);	
//		draw_rectangle(ui_x1 + 15, btn_y, ui_x1 + 15 + max_panel_w, btn_y + btn_h, false);
		
//		draw_set_halign(fa_center);
//		draw_set_valign(fa_middle);
//		draw_set_colour(c_white);
//		draw_text(ui_x1 + 15 + (max_panel_w / 2), btn_y + (btn_h / 2), "BUY BUILDING");
		
//		draw_set_valign(fa_top);
//		draw_set_colour(c_silver);
//		draw_text (ui_x1 + 15 + (max_panel_w / 2), btn_y + btn_h + 3, "$" + string(local_b_cost));
//		draw_set_colour(c_white); // Reset color
		
//	} else {
//		if(is_base){
//			inst.building_actions = (inst.current_ui_page == 1) ? inst.building_actions_p1 : inst.building_actions_p2;
//		}
		
//		//Dynamic layout calculates button layout based on building array length
//		var actions_array = inst.building_actions;
//		var total_actions = array_length(actions_array);
		
//		//Vertical button spacing
//		var list_btn_h = 22;
//		var list_spacing = 6;
//		var list_start_y = ui_y1 + 130;
		
		
//		for (var i = 0; i < total_actions; i ++) {
//			var row_y = list_start_y + (i * (list_btn_h + list_spacing));
//			var btn_w = max_panel_w;
			
//			//Call the constructors render method
//			actions_array[i].draw(ui_x1 + 15, row_y, btn_w, list_btn_h, inst);
//		}
	
//		}

//		draw_set_halign(fa_left) // reset alignment for other UI elements
//		draw_set_valign(fa_top);
//		draw_set_alpha(1.0); //reset alpha transparency
//		draw_set_colour(c_white);
//	}
 