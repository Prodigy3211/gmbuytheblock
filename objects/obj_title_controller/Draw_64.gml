// display for the title screen. Will destroy itself upon game start

var scr_w = display_get_gui_width();
var scr_h = display_get_gui_height();
var cx = scr_w / 2;
var cy = scr_h / 2;

//dark colored background. try to match game aesthetic
draw_set_colour(c_black);
draw_rectangle(0,0, scr_w, scr_h, false);

//text alignment anchors
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

//Main Game title Header (Bold, and yellow for now)
draw_set_colour(c_yellow);
draw_text_transformed(cx, cy - 80, "BUY THE BLOCK", 2.5, 2.5, 0);

//Button Box Coordinates
var btn_w = 200;
var btn_h = 50;
var btn_x1 = cx - (btn_w /2);
var btn_y1 = cy + 20;
var btn_x2 = cx + (btn_w / 2);
var btn_y2 = cy + 20 + btn_h;

//Read user mouse movements
var gui_m_x = device_mouse_x_to_gui(0);
var gui_m_y = device_mouse_y_to_gui(0);

//Is mouse hovering over button?
var is_hovering = (gui_m_x >= btn_x1 && gui_m_x <= btn_x2 && gui_m_y >= btn_y1 && gui_m_y <= btn_y2);

//Button background shape
draw_set_color(is_hovering ? c_white : c_gray);
draw_rectangle(btn_x1, btn_y1, btn_x2, btn_y2, false);

//Button text string center ovefr canvas
draw_set_colour(c_black);
draw_text_transformed(cx, btn_y1 + (btn_h / 2), "START GAME", 1.2, 1.2, 0);

//Clean up anchors
draw_set_halign(fa_left);
draw_set_valign(fa_top);