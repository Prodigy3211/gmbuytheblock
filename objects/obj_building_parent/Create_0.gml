//Default owned by city
is_owned_by_player = false;
building_cost = 5000;
income_amount = 0;
building_health= 100;
building_level = 1;
repair_cost = 150;
upgrade_cost = 400;
owned_building_color = c_green // default color
target_scale = 1.0;
is_hovered = false;
image_blend = c_dkgrey;



//Set cost based on object name

switch(object_index){
	case obj_residence:
		building_cost=250;
		income_amount=25; //5 dollars per tick
		owned_building_color = c_lime;
		break;
	case obj_commercial:
		building_cost=1500;
		income_amount=45 //45 dollars per tick
		owned_building_color = c_aqua;
		break;
	case obj_factory:
		building_cost=5000;
		income_amount= 350 //350 dollars per tick
		owned_building_color = c_fuchsia;
		break;
}