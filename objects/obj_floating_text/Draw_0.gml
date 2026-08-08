draw_set_alpha(alpha);
draw_set_color(text_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(x,y,text);

//reset to draw alhpa out.
draw_set_alpha(1.0);