TimelineRun(tlTest, 0.7);

n++;
if(!flag && n >= 300) {
	flag = true;
	TimelineMomentAdd(tlTest, 121, "C", function(val) {
		show_debug_message(val);
		TimelineMomentAdd(tlTest, 160, "D", function(val) {
			show_debug_message(val);
			TimelineMomentAdd(tlTest, 160, "E", show_debug_message);
		});
	});
	
	TimelineMomentAdd(tlTest, 140, "F", function(val) {
		show_debug_message(val);
		TimelineMomentAdd(tlTest, 60, "G", show_debug_message);
	});
}

if(keyboard_check_pressed(vk_space))
	show_debug_message(tlTest);
