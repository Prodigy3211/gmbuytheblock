//Newer Version of building highlights

//Keep buildings clear of tint when owned
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);

//If the City Owns it, give it a dark inactive look.
if (is_owned_by_player == false) {
	gpu_set_blendmode(bm_subtract);
	//Add dark sillouette
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle,c_black, 0.4);
	gpu_set_blendmode(bm_normal);
} else {
	//Player Owned highlight
	draw_set_colour(owned_building_color);
	draw_circle(x, y +(sprite_height/2) - 10, 6, false);
}

//Hover handling
if(is_hovered == true) {
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 0.25);
	gpu_set_blendmode(bm_normal);
}





//Old Version with tints

//Baseline color based on ownership of building
//var base_color = image_blend; THIS CAUSES THE BUILDINGS TO BE TINTED I DONT LIKE THIS FOR NOW.

// Brightness and blend of hover state

//if (is_hovered = true) {
	//Make the buildings stand out after checking ownership
//	if(is_owned_by_player = false) {
//		draw_sprite_ext(sprite_index, image_index, x , y, image_xscale, image_yscale, image_angle, c_gray, image_alpha);
//	} else {
		//Owned building should flash bright when hovered
//		draw_sprite_ext(sprite_index, image_index, x, y ,image_xscale, image_yscale, image_angle, c_white, image_alpha);
//	}
//} else {
	// draw normally using the typical color tint
//	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, base_color, image_alpha);
//}