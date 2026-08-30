//Building size consistency
base_width_scale = image_xscale;
base_height_scale = image_yscale;

target_scale_x = base_width_scale;
target_scale_y = base_height_scale;

//Default owned by city
is_owned_by_player = false;
building_cost = 5000;
income_amount = 0;
population_cap_bonus = 0;
influence_generation = 0;
building_health= 100;
building_level = 1;
repair_cost = 150;
upgrade_cost = 400;
owned_building_color = c_green // default color
target_scale = 1.0;
is_hovered = false;
image_blend = c_dkgrey;
is_player_base = false;
building_district = component_get_zone_by_coordinates(x);
alert_bob_timer = 0; //Animate Floating exclamation mark icon


//Set cost based on object name

switch(object_index){
	case obj_player_base:
		is_player_base = true;
		is_owned_by_player = true;
		building_cost = 0;
		building_level = 1;
		owned_building_color = c_silver;
		income_amount = 2;
		
		recruiter_count = 0; //Recruiter Unit can be bought at Player Base
		recruiter_cost = 250;
		
		//Button Page Tracker
		current_ui_page = 1;
			
			//Page 1 Buttons (Economic and Utility)
			building_actions_p1 = [
				new scr_UIButton("RECRUIT",
					function(_inst) { purchase_faction_unit("recruiter", _inst);},
					function(_inst) { return _inst.recruiter_cost; },
					function(_inst) { return (global.player_cash >= _inst.recruiter_cost); }
				),
				new scr_UIButton("REPAIR",
					function(_inst) {
						global.player_cash -= _inst.repair_cost;
						_inst.building_health = 100;
				},
				function(_inst) { return _inst.repair_cost; },
				function(_inst) { return (_inst.building_health < 100
						&& global.player_cash >= _inst.repair_cost); }
				),
				new scr_UIButton("BOOKIE",
					function(_inst) {purchase_faction_unit("bookie", _inst);},
					function(_inst) {
						var u_data = variable_struct_get(global.faction_units, "bookie");
						return (u_data != undefined) ? u_data.cash_cost : 400;
					},
					function(_inst) {
						var u_data = variable_struct_get(global.faction_units, "bookie");
						var current_price = (u_data != undefined) ? u_data.cash_cost : 400;
						return (global.player_cash >= current_price);
					}
				),
				new scr_UIButton("NEXT->",
					function(_inst) {_inst.current_ui_page = 2;},
					function(_inst) { return 0; },
					function(_inst) {return true; }
				)
			];
			
			//Page 2 buttons (Defensive and Covert Actions)
			building_actions_p2 = [
				new scr_UIButton("DEFENDER",
					function(_inst) { purchase_faction_unit("defender", _inst); },
					function(_inst) {
						var u_data = variable_struct_get(global.faction_units, "defender");
						return (u_data != undefined) ? u_data.cash_cost : 300;
					},
					function(_inst) { 
						var u_data = variable_struct_get(global.faction_units, "defender");
						var current_price = (u_data != undefined) ? u_data.cash_cost : 300;
						return (global.player_cash >= 300 && global.player_population < global.player_population_max); }
				),
				new scr_UIButton("SPY",
					function(_inst) { purchase_faction_unit("spy", _inst); },
					function (_inst) {
						var u_data = variable_struct_get(global.faction_units, "spy");
						return (u_data != undefined) ? u_data.cash_cost : 350;
					},
					function(_inst) {
						var u_data = variable_struct_get(global.faction_units, "spy");
						var current_price = (u_data != undefined) ? u_data.cash_cost: 350;
						return (global.player_cash >= current_price);
					}
				),
				new scr_UIButton("<= BACK",
					function(_inst) { _inst.current_ui_page = 1; },
					function(_inst) { return 0; },
					function(_inst) {return true; }
				)
			];
		building_actions = building_actions_p1;
		
		break;
	case obj_residence:
		building_cost=250;
		income_amount= 5; //5 dollars per tick
		population_cap_bonus = 3; // Increases Population Cap by X
		owned_building_color = c_lime;
		break;
	case obj_commercial:
		building_cost=1500;
		income_amount= 50; //45 dollars per tick
		influence_generation = 2;
		owned_building_color = c_aqua;
		break;
	case obj_factory:
		building_cost=5000;
		income_amount= 350; //350 dollars per tick
		influence_generation = 8;
		owned_building_color = c_orange;
		break;
	case obj_temple:
		building_cost=15000;
		population_generation = 1;
		owned_building_color = c_green;
		income_amount = 1000; // Need to update this to a percentage of the population
		//to simulate a 10% tithe.
		influence_generation = 15;
		break;
}

//2 Button layout for regular buildings

if (is_player_base == false){
	building_actions = [
		new scr_UIButton("UPGRADE",
					function(_inst) {
						global.player_cash -= _inst.upgrade_cost;
						_inst.building_level += 1;
						_inst.income_amount += 20;
						_inst.upgrade_cost *= 2;
						audio_play_sound(snd_upgrade, 10,false);
				},
				function(_inst) { return _inst.upgrade_cost; },
				function(_inst) { return (_inst.building_level < 5
						&& global.player_cash >= _inst.upgrade_cost); }
	),
	new scr_UIButton("REPAIR",
					function(_inst) {
						global.player_cash -= _inst.repair_cost;
						_inst.building_health = 100;
						audio_play_sound(snd_unlock, 10, false);
				},
				function(_inst) { return _inst.repair_cost; },
				function(_inst) { return (_inst.building_health < 100
						&& global.player_cash >= _inst.repair_cost); }
					)
	];
}