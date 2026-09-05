function building_shake(_building_id,_magnitude, _frames){
	if(instance_exists(_building_id)){
		with(_building_id){
			if(_magnitude > shake_remain){
				shake_remain = _magnitude;
				shake_decay = _magnitude / _frames;
				
				//foce an offset calculation so it doens't wait for a frame
				shake_x_offset = random_range(-_magnitude, _magnitude);
				shake_y_offset = random_range(-_magnitude, _magnitude);
			}
		}
	}
}