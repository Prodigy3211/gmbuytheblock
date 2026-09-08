//Smoothly return building to normal size

image_xscale = lerp(image_xscale, target_scale, 0.15);
image_yscale = lerp(image_yscale, target_scale, 0.15);

//Stretch building size over time when needed
target_scale_x = lerp(target_scale_x, base_width_scale, 0.1);
target_scale_y = lerp(target_scale_y, base_height_scale, 0.1);


//Increment timer for bouncing animation for alert indicator
alert_bob_timer += 0.05;


//Building shake Math
if(shake_remain > 0){
	//Offset for THIS frame
	shake_x_offset = random_range(-shake_remain, shake_remain);
	shake_y_offset = random_range(-shake_remain, shake_remain);
	
	//Decay the shake intensity
	shake_remain = max(0, shake_remain - shake_decay)
} else {
	shake_x_offset = 0;
	shake_y_offset = 0;
}