//Baseline color based on ownership of building
var base_color = image_blend;

// Brightness and blend of hover state

if (is_hovered = true) {
	//Make the buildings stand out after checking ownership
	if(is_owned_by_player = false) {
		draw_sprite_ext(sprite_index, image_index, x , y, image_xscale, image_yscale, image_angle, c_gray, image_alpha);
	} else {
		//Owned building should flash bright when hovered
		draw_sprite_ext(sprite_index, image_index, x, y ,image_xscale, image_yscale, image_angle, c_white, image_alpha);
	}
} else {
	// draw normally using the typical color tint
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, base_color, image_alpha);
}