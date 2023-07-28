tlTest = TimelineCreate();
var i = 0;
var f = function(val) { show_debug_message(val); };
TimelineMomentAdd(tlTest, 0, i++, function(val) { show_debug_message(val); });
TimelineMomentAdd(tlTest, 1, i++, f);
TimelineMomentAdd(tlTest, 60, i++, show_debug_message);
repeat(5) {
	TimelineMomentAdd(tlTest, 90, i++, show_debug_message);
}
TimelineMomentAdd(tlTest, 120, i++, function(val) {
	show_debug_message(val);
	TimelineMomentAdd(tlTest, 121, "A", function(val) {
		show_debug_message(val);
		TimelineMomentAdd(tlTest, 121, "B", show_debug_message);
	});
});
TimelineMomentClear(tlTest, 90);

flag = false;
n = 0;
