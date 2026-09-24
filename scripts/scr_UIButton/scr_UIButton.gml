//This will replace the building button If statement crazines. If you need a button, use this script

function scr_UIButton(_label, _callback, _cost_getter, _enabled_getter) constructor {
	label = _label;
	callback = _callback; //Executes functions on a click
	cost_getter = _cost_getter; // Returns current cost
	enabled_getter = _enabled_getter // Is the buttone active?
	
	//Uniform Math and visual Drawing
	static draw = function(x1, y1, w, h, _inst){
		var cost = cost_getter(_inst);
		var enabled = enabled_getter(_inst);
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		
		//Dynamic hovering recognition state
		var is_hovered = (mx >= x1 && mx <= x1 + w && my >= y1 && my <= y1 +h);
		
		
		//Determine fill context palette
		if(!enabled) {
			draw_set_colour(c_dkgray);
		} else if (is_hovered){
			draw_set_colour(c_silver);
		} else {
			draw_set_colour(c_gray);
		}
		
		//Draw Rectangle base
		draw_rectangle(x1, y1, x1 + w, y1 + h, false);
		
		
		//Pre calculate vertical and horizontal marks
		var text_cx = x1 + (w/ 2);
		var text_cy = y1 + (h / 2);
		
		//draw text labels
		draw_set_colour(c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text(text_cx, text_cy, label);
		
		//Draw the Sub-Label Price below the buttons
		if (cost > 0) {
			draw_set_colour(c_silver);
			draw_set_halign(fa_right);
			draw_text(x1 + w - 12, text_cy, "$" + string(cost));
		}
		//Reset
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
	};
	
	//Hit box testing isolation
	static check_click = function(x1, y1, w, h, _inst){
		if(!enabled_getter(_inst)) return false;
		
		var mx = device_mouse_x_to_gui(0);
		var my = device_mouse_y_to_gui(0);
		
		if (mx >= x1 && mx <= x1 + w && my >= y1 && my <= y1 + h) {
			callback(_inst); // Fire execution instructions
			return true;
		}
		return false;
	};

}