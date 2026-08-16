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
building_district = "Downtown";


//Set cost based on object name

switch(object_index){
	case obj_player_base:
		is_player_base = true;
		is_owned_by_player = true;
		building_cost = 0;
		building_level = 1;
		owned_building_color = c_silver
		income_amount = 2;
		
		recruiter_count = 0; //Recruiter Unit can be bought at Player Base
		recruiter_cost = 250;
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