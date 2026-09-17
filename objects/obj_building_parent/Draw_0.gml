//Newer Version of building highlights

var draw_x = x + (variable_instance_exists(id, "shake_x_offset") ? shake_x_offset : 0);
var draw_y = y + (variable_instance_exists(id, "shake_y_offset") ? shake_y_offset : 0);




//If the City Owns it, give it a dark inactive look.
if (is_owned_by_player == false) {
	var drab_gray = make_color_rgb(100, 105, 115);
	//Add dark sillouette
	draw_sprite_ext(sprite_index, image_index, draw_x, draw_y, image_xscale, image_yscale, image_angle,drab_gray, image_alpha);
} else {
	draw_sprite_ext(sprite_index, image_index, draw_x, draw_y, image_xscale, image_yscale, image_angle,c_white, image_alpha);
	//Player Owned highlight
	draw_set_colour(owned_building_color);
	draw_circle(draw_x, draw_y +(sprite_height/2) - 10, 6, false);
}

//Hover handling
if(is_hovered == true) {
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(sprite_index, image_index, draw_x, draw_y, image_xscale, image_yscale, image_angle, c_white, 0.25);
	gpu_set_blendmode(bm_normal);
}


//Sabotage Distress Indicator
//Only display icon if pplayer owns it and building damaged enough to stop providing resources'
if (is_owned_by_player == true && building_health <= 30) {
	
	if(sin(current_time * 0.003) > 0){
		//Pulsing Red Warning Tint over building
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprite_index, image_index, draw_x, draw_y, image_xscale, image_yscale, image_angle, c_red, 0.3);
		gpu_set_blendmode(bm_normal);
		
		//Calucation for full fire animation speed
		var fire_frame = (current_time /200) % 7;
		
		//Building type one: Standard
		switch(object_index){
			
			case obj_residence:
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 4 , draw_y); //Left side foundation
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 22, draw_y - 20) // Right side upper level
				break;
				
				case obj_commercial:
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 12, draw_y); // Doorway
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 16, draw_y - 32); //Middle window row
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 8 , draw_y - 64);
				break;
			case obj_factory:
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 40, draw_y) // Left garage door
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 32, draw_y) // right wall
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 12, draw_y - 40) // High Window
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 20, draw_y - 70) // Smoke Stack
				break;
			case obj_temple:
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 32, draw_y - 16) // Left stairs
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 32, draw_y - 16) // Right stairs
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 20, draw_y - 60) // Pillars
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 16, draw_y - 110) //Upper sanctum
				draw_sprite(spr_damage_fire, fire_frame, draw_x, draw_y - 140) // Dome Peak
				break;
			case obj_player_base:
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 24, draw_y) // Left side
				draw_sprite(spr_damage_fire, fire_frame, draw_x + 24, draw_y) // Right base
				draw_sprite(spr_damage_fire, fire_frame, draw_x, draw_y - 45) // Center balcony
				draw_sprite(spr_damage_fire, fire_frame, draw_x - 10, draw_y - 90) // Near Attenna
				break;
			default: //fallback
			draw_sprite(spr_damage_fire, fire_frame, draw_x, draw_y)
			break;
		}
		
		
		////Stamp Fire sprite on top of building
		//draw_sprite(spr_damage_fire, fire_frame, draw_x, draw_y);
	
		////If it's a wide building
		//if(sprite_width > 64){
		//	draw_sprite(spr_damage_fire, fire_frame, draw_x + 32, draw_y);
		//}
	}
	
	//gentle floating bounce calculation.. will be a sine wave
	var bob_offset = sin(alert_bob_timer) * 6;
	
	//place the icon above the building sprite
	var sprite_center_offset = (sprite_get_width(sprite_index) / 2 ) - sprite_get_xoffset(sprite_index);
	var icon_x = draw_x + (sprite_center_offset * image_xscale) ;
	var icon_y = (draw_y - ((sprite_height * image_yscale) / 2)) - 25 + bob_offset;
	
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