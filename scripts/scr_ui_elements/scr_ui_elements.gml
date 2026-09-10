//Draws a clean "PrompT" banner at the top center of the screen


function draw_objective_banner(_text, _color){
	//Get current layout size
	var gui_w = display_get_gui_width();
	var box_w = string_width(_text) + 40;
	var box_h = 32;
	
	var x1 = (gui_w / 2) - (box_w / 2);
	var y1 = 12;
	var x2 = (gui_w / 2) + (box_w / 2);
	var y2 = y1 + box_h;
	
	//Render background container
	draw_set_color(c_black);
	draw_set_alpha(0.75);
	draw_roundrect_ext(x1, y1, x2, y2, 8, 8, false);
	
	//render contexxtual border accent color
	draw_set_color(_color);
	draw_roundrect_ext(x1,y1,x2,y2,8,8,true)
	
	//render text inside the container boundaries
	draw_set_alpha(1.0);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(c_white);
	draw_text(gui_w / 2, y1 + (box_h / 2), _text);
	
	//Reset formatting hooks
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

}