//Drawing sector boundaries

var cx = room_width / 2;
var cy = room_height / 2;
var box_w = 800;
var box_h = 600;

draw_set_alpha(0.25);
draw_set_colour(c_purple);

//Draw Quadrant Dividing lives(Left right Top bottom)
draw_line_width(cx, 0, cx, room_height, 4); //Vertical center
draw_line_width(0, cy, room_width,cy , 4); //Horizontal Center

//central Box
draw_set_colour(c_lime);
draw_rectangle(cx - box_w/ 2, cy - box_h / 2, cx + box_w / 2, cy + box_h / 2, true);

//Print Helper Labels
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(cx, cy, "CAPITOL HILL");
draw_text(cx - 400, cy - 300, "West Side");
draw_text(cx - 400, cy + 300, "Downtown");
draw_text(room_width * 0.75, room_height * 0.25, "East Side");
draw_text(room_width * 0.75, room_height * 0.75, "Uptown");

draw_set_alpha(1.0); // Reset alpha layout transparency
draw_set_valign(fa_top);
draw_set_halign(fa_left);