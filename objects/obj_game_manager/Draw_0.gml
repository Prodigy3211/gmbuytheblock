//Drawing sector boundaries

var sector_width = room_width / 5;
draw_set_alpha(0.3); //Grid boundaries should be subtle

for (var i = 1; i < 5; i++) {
		var line_x = i * sector_width;
		
		//Draw thin purple separator line splitting the neighborhoods
		draw_set_colour(c_purple);
		draw_line_width(line_x, 0, line_x, room_height, 3);
		
		//draw the name of the sector floating over the boundary
		
		draw_set_halign(fa_center);
		draw_text(line_x, 100, "<- ZONE BOUNDARY ->");
}

draw_set_alpha(1.0); // Reset alpha layout transparency