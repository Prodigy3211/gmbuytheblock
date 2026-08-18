//Smoothly return building to normal size

image_xscale = lerp(image_xscale, target_scale, 0.15);
image_yscale = lerp(image_yscale, target_scale, 0.15);


//Increment timer for bouncing animation for alert indicator
alert_bob_timer += 0.05;