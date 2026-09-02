var scr_w = display_get_gui_width();
var scr_h = display_get_gui_height();
var cx = scr_w / 2;
var cy = scr_h / 2;

//Instructions card
if(show_instructions == true) {
	
	
	
	// Full Screen backdrop panel
	draw_set_colour(c_black);
	draw_set_alpha(0.9);
	draw_rectangle(0,0, scr_w , scr_h, false);
	
	//text alignment
	draw_set_alpha(1.0);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	//Header
	draw_set_color(c_yellow);
	draw_text_transformed(cx, cy - 120, "How To Buy The Block!", 1.5, 1.5, 0);
	
	//Row Item Instructions
	draw_set_colour(c_white);
	draw_text(cx, cy - 60, "- Use WASD or Arrow Keys to navigate and pan across the city map.");
	draw_text(cx, cy - 30,"- Left-Click buildings to BUY them. Once bought you can UPGRADE them to generate more cash.");
	draw_text(cx, cy, "- Watch your building's health! Use the REPAIR button to return your house to full health");
	draw_text(cx, cy + 30,"- If a building's health drops to 0% the Government will take it back and you'll have to buy it again");
	draw_text(cx, cy + 60,"- Buy Recruiters and Expand your POPULATION Cap to get more influence and unlock new districts");
	draw_text(cx, cy + 90,"Hire base Defenders to make it harder for the government to sabotage your buildings!");
	
	//Footer
	draw_set_color(c_lime);
	draw_text(cx, cy +160, "[ Left-Click anywhere to start the game ]");
	
	//Resert layout anchors
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	exit;
}


//RESOURCE TRACKING CARD

//text alignment and size
draw_set_halign(fa_left);
draw_set_valign(fa_top);

//Draw a dark background box for readability

draw_set_colour(c_black);
draw_alpha= 0.5;
draw_rectangle(10,10,320,130,false); //Background big enough to have cash and progress bar

//Draw the cash text in green
draw_set_alpha(1.0);
draw_set_colour(c_lime);
var cash_str = "Cash: $" +string(global.player_cash) + " (+$" + string(global.net_cash_tick) + ")";
draw_text_transformed(20,18,cash_str, hud_cash_scale,hud_cash_scale, 0);

//Draw the Population Tracker
draw_set_colour(c_orange);
draw_text(20, 44, "Population: " + string(global.player_population) + " / " +string(global.player_population_max));

//Influence Tracker
draw_set_colour(c_purple);
var inf_str = "Influence: " + string(global.player_influence) + " (+" + string(global.net_influence_tick) + ")";
draw_text(20,70,inf_str);


// City Buyout Percentage Text
draw_set_colour(c_white);
draw_text(20, 96, "City Buyout: " + string(global.city_owned_percent) + "%");


//Enemy Threat Meter
draw_set_colour(c_dkgray);
draw_rectangle(20, 125, 200, 135, false) //empty background for a gauge

//color shift from yellow to red
var threat_color = make_colour_rgb((global.enemy_threat / 100) * 255, 50, 50);
draw_set_colour(threat_color);

//Fill section of the bar graph
var bar_fill_x = 20 + ((200 - 20) * (global.enemy_threat /100));
draw_rectangle(20, 125, bar_fill_x, 135, false);

//Show numerical percentage
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_text(210, 121, "Government Anger: " +string(floor(global.enemy_threat)) + "%");


//Draw out the Building Inspectional Panel if Building is Selected
 
 if (global.selected_building != noone) {
	
	
	
	//create shortcuts for selected building's data
	
	var b_health = global.selected_building.building_health;
	var b_cost = global.selected_building.building_cost;
	var b_owned = global.selected_building.is_owned_by_player;
	
	var can_afford_repair = (global.player_cash >= global.selected_building.repair_cost);
	var can_repair = (global.player_cash >= global.selected_building.repair_cost && b_health < 100);
	var can_upgrade = (global.player_cash >= global.selected_building.upgrade_cost);
	
	var is_maxed = (global.selected_building.building_level >= 5);
	var is_base = global.selected_building.is_player_base;
	var inst = global.selected_building;
	
	var district_data = variable_struct_get(global.districts, inst.building_district);
	var is_unlocked = district_data.unlocked;
	var unlock_cost = district_data.cost;
	
	var recruiter_data = global.faction_units.recruiter;
	var defender_data = global.faction_units.defender;
	
	
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
	draw_text(ui_x1 + 20, ui_y1 + 18, "Status: " + owner_text);
	//draw_text(ui_x1 + 20, ui_y1 + 40, "Price: $" +string(b_cost));
	draw_text(ui_x1 + 20, ui_y1 + 62, "Condition: " +string(ceil(b_health)) +" %");
	
	//Upgrade
	
	//Upgrade Level
	if(b_owned == true) {
		draw_set_colour(c_yellow);//The goal is to make this stand out
		draw_text(ui_x1 + 20, ui_y1 + 84, "Current Level: Tier " + string(global.selected_building.building_level));
		draw_set_colour(c_white); //reset text to white
	}
	
	if (is_base == true) {
		draw_set_colour(c_orange);
		draw_text(ui_x1 + 20, ui_y1 + 106, "Recruiters: " + string(global.selected_building.recruiter_count));
		
		//Faction Army count
		draw_set_color(c_orange);
		draw_set_halign(fa_left);
		draw_text(ui_x1 + 160, ui_y1 + 106, "Defenders: " + string(global.garrison_units));
	}
	
	//visual Health Bar (shifted up to avoid blocking buttons)
	var bar_x1 = ui_x1 + 20;
	var bar_y1 = ui_y1 + 132;
	var bar_x2 = ui_x2 - 20;
	var bar_y2 = ui_y1 + 144;
	
	draw_set_colour(c_dkgray)
	draw_rectangle(bar_x1, bar_y1, bar_x2, bar_y2, false); //Empty bar's background
	
	// color changes from green to red based on damage
	//want to add a visual indicator of damage as well.
	
	var health_color = (b_health > 40) ? c_green : c_red;
	draw_set_colour(health_color);
	
	//final width percent calculator. fill health bar calcs?
	
	var bar_fill = bar_x1 + ((bar_x2 -bar_x1) * (b_health / 100 ));
	draw_rectangle(bar_x1, bar_y1, bar_fill, bar_y2, false);
	
	//BUTTON DRAW LOOPS
	
	var btn_y = ui_y1 + 158;
	var btn_h = 24;
	var max_panel_w = 285;
	
	//We are next the buy buttons inside of a new Sector Unlock section
	
	if(is_unlocked == false){
		//Fetch how much money it costs to unlock
		var cash_unlock_cost = component_get_district_unlock_cash_cost(inst.building_district);
		
		//Check if you can afford with Influence
		var can_afford_unlock = (global.player_influence >= unlock_cost && global.player_cash >= cash_unlock_cost);
	
	//Draw the unlock box
	draw_set_colour(can_afford_unlock ? c_gray : c_dkgray);
	draw_rectangle(ui_x1 + 15, btn_y, ui_x1 + 15+ max_panel_w, btn_y +btn_h, false);
	
	//Draw the label for Unlock
	draw_set_colour(c_white);
	draw_set_halign(fa_center);
	draw_text(ui_x1 + 15 + (max_panel_w/ 2), btn_y + 4, "UNLOCK DISTRICT");
	
	//Print the cost notification in purple on the side
	draw_set_colour(c_purple);
	draw_set_halign(fa_left);
	draw_text(ui_x1 + 20, ui_y1 + 84, inst.building_district + " Zone: " + string(unlock_cost) + " Influence");
	
	//display cash cost
	draw_set_colour(c_lime);
	draw_text(ui_x1 + 20, ui_y1 + 104, "Requires: $" + string(cash_unlock_cost) + " Cash");
	
	
	} else if (b_owned == false) {
	//Button A (Buy or Upgrade) Left Button Slot 'Buy, Hire,Max Leve, Upgrade'	
	
		var local_b_cost = component_calculate_building_purchase_cost(b_cost, inst.building_district);
	
		//BUY BUTTON
		var can_buy = (global.player_cash >= local_b_cost);
		draw_set_colour(can_buy ? c_gray : c_dkgray);	
		draw_rectangle(ui_x1 + 15, btn_y, ui_x1 + 15 + max_panel_w, btn_y + btn_h, false);
		
		draw_set_halign(fa_center);
		draw_set_colour(c_white);
		draw_text(ui_x1 + 15 + (max_panel_w / 2), btn_y + 4, "BUY BUILDING");
		
		draw_set_colour(c_silver);
		draw_text (ui_x1 + 15 + (max_panel_w / 2), btn_y + btn_h + 3, "$" + string(local_b_cost));
		
	} else {
		if(inst.is_player_base == true){
			inst.building_actions = (inst.current_ui_page == 1) ? inst.building_actions_p1 : inst.building_actions_p2;
		}
		
		//Dynamic layout calculates button layout based on building array length
		var actions_array = inst.building_actions;
		var total_actions = array_length(actions_array);
		
		var space_per_button = max_panel_w / total_actions;
		var btn_w = space_per_button - 10; //For space between rectangles
		
		for (var i = 0; i < total_actions; i ++) {
			var btn_x = (ui_x1 +15) + (i * space_per_button);
			
			//Call the constructors render method
			actions_array[i].draw(btn_x, btn_y, btn_w, btn_h, inst);
		}
	
		}

		draw_set_halign(fa_left) // reset alignment for other UI elements
		draw_set_alpha(1.0); //reset alpha transparency
	}
 
	

	
	//beroom
//	boon_owned == fixile
	
	
	//How to close the panel
//	draw_set_colour(c_dkgray);
	//draw_text(ui_x1 + 20, ui_y1 + 160, "Press [esc] ti deselect");
//}

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
		draw_text(screen_cx, screen_cy + 20, "You successfully own this bitch! Press 'R' to restart.");
	} else if (game_over_state == "lose") {
		draw_set_colour(c_red);
		draw_text(screen_cx, screen_cy - 20, "You lost our Headquarters!? You SUCK!");
		draw_set_colour(c_white);
		draw_text(screen_cx, screen_cy + 20, "The city has frozen your assets and reclaimed your property. Press 'R' to Try again.");
	}
}