// Instructions check
if(show_instructions = true){
	//resets clock until player leaves instructions screen
alarm[1] = 1500
exit;
}

//30% chance of a random event trigger
if (random(100) <= 30) {
	//Script Call for Disaster
	component_trigger_natural_disaster();
}
//reset clock for frequency
alarm[1] = 1500;