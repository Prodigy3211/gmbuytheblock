// Fade out over time
alpha -= fade_speed;

//destroy once completely invisibile to save memory

if (alpha <= 0) {
	instance_destroy();
}