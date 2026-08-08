global.player_cash = 1000;
global.selected_building = noone; //ensures that no building is selected as default


//Payout timer (60 frames = 1 second at 60fps. 30 frames = 1secone at 30fps)

payout_rate = 60;
alarm[0] = payout_rate;


//random event every 10 seconds
alarm[1] = 600;

//Win or Lose
game_over_state = "playing"; //can switch to win or lose