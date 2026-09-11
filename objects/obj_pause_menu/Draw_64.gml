var scr_w = display_get_gui_width();
var scr_h = display_get_gui_height();
var cx = scr_w / 2;
var cy = scr_h / 2;

//dark background
draw_set_color(c_black);
draw_set_alpha(0.65);
draw_rectangle(0, 0, scr_w, scr_h, false);

//Draw menu container
var box_w = 340;
var box_h = 200; //sized for two buttons make bigger for quit button
draw_set_alpha(0.9);
draw_roundrect_ext(cx - (box_w / 2), cy - (box_h / 2), cx + (box_w / 2), cy + (box_h / 2), 12 , 12, true);

//Header

draw_set_alpha(1.0);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(cx, cy - 50, "GAME PAUSED", 1.5, 1.5, 0);

//Render menu
var menu_options = ["RESUME", "RESTART"];

for(var i = 0; i < array_length(menu_options); i++){
	var text_y = cy + 10 + (i * 45);
	
	if (pause_selected == i) {
		draw_set_color(c_orange); //selection highlight
		draw_text(cx, text_y, "> " + menu_options[i] + " <");
	} else {
		draw_set_color(c_gray);
		draw_text(cx, text_y, menu_options[i]);
	}
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);