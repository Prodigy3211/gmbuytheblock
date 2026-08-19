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


//Sabotage Distress Indicator
//Only display icon if pplayer owns it and building damaged enough to stop providing resources'
if (is_owned_by_player == true && building_health <= 30) {
	
	//gentle floating bounce calculation.. will be a sine wave
	var bob_offset = sin(alert_bob_timer) * 6;
	
	//place the icon above the building sprite
	var sprite_center_offset = (sprite_get_width(sprite_index) / 2 ) - sprite_get_xoffset(sprite_index);
	var icon_x = x + (sprite_center_offset * image_xscale) ;
	var icon_y = (y - ((sprite_height * image_yscale) / 2)) - 25 + bob_offset;
	
	//Bold High contract red ! indicator
	draw_set_colour(c_red);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	//draw the actual Symbol text
	draw_text_transformed(icon_x, icon_y, "!", 1.5, 1.5, 0);
	
	//Draw a small border behind the ! icon
	draw_circle(icon_x, icon_y + 2, 14, true);
	
	//reset alignment to standard layout
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
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