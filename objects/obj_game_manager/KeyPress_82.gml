//Allow restart after game win or lose

if(game_over_state == "win" || game_over_state = "lose"){
	global.player_cash = 1000;
	global.selected_building = noone;
	game_over_state = "playing";
	
	room_restart();
}