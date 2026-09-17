//This is not working right now. It saves EBEYRTHING But the buildings you bought.

function game_save_progress(){
	//Initialize the data struct
	var save_package = {};
	
	//Inject all core global states for economy
		save_package.player_cash = global.player_cash;
		save_package.enemy_threat = global.enemy_threat;
		save_package.city_owned_percent = global.city_owned_percent;
		save_package.selected_building = global.selected_building;
		save_package.player_influence = global.player_influence;
		save_package.player_population = global.player_population;
		save_package.player_population_max =	global.player_population_max;
		save_package.net_cash_tick = global.net_cash_tick;
		save_package.net_influence_tick = global.net_influence_tick;
		save_package.garrison_units = global.garrison_units;
		save_package.story_phase = global.story_phase;
		save_package.story_active = global.story_active;
		save_package.active_story_struct = global.active_story_struct;
		save_package.story_unit_cost_multiplier = global.story_unit_cost_multiplier;
		save_package.triggered_homebase_siege = global.triggered_homebase_siege;
		save_package.triggered_ownership_25 = global.triggered_ownership_25;
		save_package.triggered_final_lockdown = global.triggered_final_lockdown;
		save_package.triggered_ownership_50 = global.triggered_ownership_50;
		save_package.districts_data = global.districts;
		
		//NOTE THE BUILDINGS ARE NOT OBJECTS ON THE MAP RIGHT NOW THEY ARE painted on the grid
		//Inject map layout
		save_package.tilemap_grid_array = [];
		
		//Locate physical tilemap layer asset in Room1
		var _layer_id = layer_get_id("ts_city_environment");
		var _tilemap_id = layer_tilemap_get_id(_layer_id);
		
		//calculate grids and rows
		var _map_cols = tilemap_get_width(_tilemap_id);
		var _map_rows = tilemap_get_height(_tilemap_id);
		
		for (var yy = 0; yy < _map_rows; yy++) {
			for (var xx = 0; xx < _map_cols; xx++) {
				//extract unique image tiles
				var _tile_data = tilemap_get(_tilemap_id, xx, yy);
				
				//if the grid slot isnt blank
				if(_tile_data != 0) {
					var _cell_profile = {
						grid_x: xx,
						grid_y: yy,
						tile_index: _tile_data
					};
					array_push(save_package.tilemap_grid_array, _cell_profile);
				}
			}
		}
		
		//var _all_buildings = [obj_player_base, obj_residence, obj_commercial, obj_factory, obj_temple];
		
		//for (var i = 0; i < array_length(_all_buildings); i++){
		//	var _target_object_type = _all_buildings[i];
			
		//	//How many instances of this speicifc building exist?
			
		//	var _inst_count = instance_number(_target_object_type);
			
		//	for(var k =0; k< _inst_count; k++){
		//		var _inst = instance_find(_target_object_type, k);
				
		//		if(instance_exists(_inst)){
		//			var _building_data = {
		//		object_type: object_get_name(_inst.object_index),
		//		grid_x: _inst.x,
		//		grid_y: _inst.y,
		//		owned: _inst.is_owned_by_player,
		//		hp: _inst.building_health,
		//		tier: _inst.building_level,
		//		district: variable_instance_exists(_inst.id, "building_district") ? _inst.building_district : "West Side"
		//	};
		//			//push this package into the building array
		//	array_push(save_package.buildings_array, _building_data);
		//}
		
	 //}
//}
		
// convert to a JSON
var json_string = json_stringify(save_package);

//Open a text file to save this data
var _buffer = buffer_create(string_byte_length(json_string) + 1, buffer_fixed, 1);
buffer_write(_buffer, buffer_string, json_string);
buffer_save(_buffer, working_directory + "save_data.txt");
buffer_delete(_buffer); // clean out RAM

//We want to try a buffer save function instead of the below var File so that gamemaker doesn't cut off longer strings
//var file = file_text_open_write(working_directory + "save_data.txt");
//file_text_write_string(file, json_string);
//file_text_close(file);

show_debug_message("Success The file has been saved.")
show_debug_message("--- ACTIVE ROOM: " + room_get_name(room) + " | INSTANCE COUNT: " + string(instance_count) + " ---");
show_debug_message("--- EXPORT VALIDATION: Saved " + string(array_length(save_package.tilemap_grid_array)) + " tile plots ---");

}

//Load function
function game_load_progress(){
	//safety check if file doesn't exist. End the function
	var file_path = working_directory + "save_data.txt";
	if(!file_exists(file_path)) {
		show_debug_message("LOAD ERROR NO FILE DETECTED");
		return false;
	}
	
	//open the text file
	var _buffer = buffer_load(file_path);
	var json_string = buffer_read(_buffer, buffer_string);
	buffer_delete(_buffer);
	
//decompress the string text
	var load_package = json_parse(json_string);
	
	//Grid Wipe Sequence
	var _layer_id = layer_get_id("ts_city_environment");
	var _tilemap_id = layer_tilemap_get_id(_layer_id);
	tilemap_clear(_tilemap_id, 0) // clears the screen;s painted stamps
	
	////Clear the board to prevent duplicates
	//with(obj_building_parent) instance_destroy();
	
	
	//restore all fundamental core stats
	global.player_cash = load_package.player_cash;
	global.enemy_threat = load_package.enemy_threat;
	global.city_owned_percent = load_package.city_owned_percent;
	global.selected_building = load_package.selected_building;
	global.player_influence = load_package.player_influence;
	global.player_population = load_package.player_population;
	global.player_population_max =	load_package.player_population_max;
	global.net_cash_tick = load_package.net_cash_tick;
	global.net_influence_tick = load_package.net_influence_tick;
	global.garrison_units = load_package.garrison_units;
	global.story_phase = load_package.story_phase;
	global.story_active = load_package.story_active;
	global.active_story_struct = load_package.active_story_struct;
	global.story_unit_cost_multiplier = load_package.story_unit_cost_multiplier;
	global.triggered_homebase_siege = load_package.triggered_homebase_siege;
	global.triggered_ownership_25 = load_package.triggered_ownership_25;
	global.triggered_final_lockdown = load_package.triggered_final_lockdown;
	global.triggered_ownership_50 = load_package.triggered_ownership_50;
	global.districts = load_package.districts_data;
	
	//recontruct painted grid
	var _total_saved_tiles = array_length(load_package.tilemap_grid_array);
	
	for (var i = 0; i < _total_saved_tiles; i++){
			var _t_data = load_package.tilemap_grid_array[i];
			//re stamp the graphic at the location
			tilemap_set(_tilemap_id, _t_data.tile_index, _t_data.grid_x, _t_data.grid_y);
	
	}
	
	
	//reconstruct the world
	//var _total_saved_buildings = array_length(load_package.buildings_array);
	
	//for (var i = 0; i < _total_saved_buildings; i++) {
	//	var _b_data = load_package.buildings_array[i];
		
	//	//convert the string into asset id
	//	var _object_asset_id = asset_get_index(_b_data.object_type);
		
	//	//If ID is valid then spawn it to the instance
	//	if(_object_asset_id != -1) {
			
			
	//		//Check layer
	//		var _target_layer = layer;
	//		if(_target_layer == -1) _target_layer = "Instances";
			
	//		//Need to convert "Is Owned" from true to false to 1 or 0 for the load function to work
			
			
	//		var _new_inst = instance_create_layer(_b_data.grid_x, _b_data.grid_y, _target_layer, _object_asset_id);
			
	//		with(_new_inst){
	//			is_owned_by_player = (_b_data.owned == true || _b_data.owned == 1 || string(_b_data.owned) == "true"); //should check for all owned data
	//			building_health = _b_data.hp;
	//			building_level = _b_data.tier;
	//			building_district = _b_data.district;
				
	//			//Loops through and simulates upgrade math
	//			if(building_level > 1) {
	//				repeat(building_level - 1){
	//					income_amount = round(income_amount * 1.4);
	//					upgrade_cost *= 2;
	//				}
	//			}
	//			//Re run visuals to update the sprite
	//			component_update_building_visuals(id);
				
	//		};
			
			
			
	//	}
	//}

	global.selected_building = noone;

	audio_play_sound(snd_upgrade, 10, false);
	show_debug_message("GAME LOADED! NOICE")
	return true;

}