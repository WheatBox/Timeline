/// @desc 创建时间线
/// @returns {struct} 时间线
function TimelineCreate() {
	return {
		time : -1, // 当前推进到了哪一时间点
		moment : -1, // 当前推进到了哪一时刻，对应下方数组的下标
		arrTime : [], // 存储时间点的数组
		arrArgs : [], // 存储函数所需参数的数组
		arrFunc : [], // 存储函数的数组
	};
}

/**
 * 为时间线加入新时刻
 * @param {struct} _timeline 时间线
 * @param {real} _step 时间点
 * @param {any*} _args 参数，无参数则填写undefined，多个参数可使用结构体或数组进行传递
 * @param {any*} _func 函数
 * @param {bool} _stepIsRelative 前面的_step为 绝对 还是 根据最后一个时刻的时间点相对，false(默认) = 绝对，true = 相对
 */
function TimelineMomentAdd(_timeline, _step, _args, _func, _stepIsRelative = false) {
	var _len = array_length(_timeline.arrTime);
	if(_len <= 0) {
		if(_step < 0) {
			_step = 0;
		}
		
		if(_timeline.moment >= 0) {
			_timeline.moment++;
		}
		
		array_push(_timeline.arrTime, _step);
		array_push(_timeline.arrArgs, _args);
		array_push(_timeline.arrFunc, _func);
		
		return;
	}
	
	var _findL = 0, _findR = _len - 1;
	
	if(_stepIsRelative) {
		_step += _timeline.arrTime[_findR];
	}
	if(_step < 0) {
		_step = 0;
	}
	
	if(_timeline.arrTime[_findR] <= _step) {
		if(_timeline.moment >= _len) {
			_timeline.moment++;
		}
		
		array_push(_timeline.arrTime, _step);
		array_push(_timeline.arrArgs, _args);
		array_push(_timeline.arrFunc, _func);
		
		return;
	}
	
	// 在时间线上根据时间点来二分查找插入当前时刻的正确时刻
	var _findI = floor((_findL + _findR) / 2);
	while(_findL <= _findR) {
		if(_timeline.arrTime[_findI] < _step) {
			_findL = _findI + 1;
			_findI = floor((_findL + _findR) / 2);
		} else if(_timeline.arrTime[_findI] > _step) {
			_findR = _findI - 1;
			_findI = floor((_findL + _findR) / 2);
		} else { // 如果时间线上该时间点已有时刻，则将当前时刻插入到这些相同时间点时刻的最后
			for(_findI++; _findI < _len; _findI++) {
				if(_step < _timeline.arrTime[_findI]) {
					break;
				}
			}
			_findL = _findI;
			break;
		}
	}
	
	array_insert(_timeline.arrTime, _findL, _step);
	array_insert(_timeline.arrArgs, _findL, _args);
	array_insert(_timeline.arrFunc, _findL, _func);
	
	if(_findL <= _timeline.moment) {
		_timeline.moment++;
	}
}

/**
 * 清除时间线上某一时间点的所有时刻
 * @param {struct} _timeline 时间线
 * @param {real} _step 时间点
 */
function TimelineMomentClear(_timeline, _step) {
	var _len = array_length(_timeline.arrTime);
	if(_len <= 0) {
		return;
	}
	
	var _findL = 0, _findR = _len - 1;
	
	if(_step < 0) {
		_step = 0;
	}
	
	var _findI = floor((_findL + _findR) / 2);
	while(_findL <= _findR) {
		if(_timeline.arrTime[_findI] < _step) {
			_findL = _findI + 1;
			_findI = floor((_findL + _findR) / 2);
		} else if(_timeline.arrTime[_findI] > _step) {
			_findR = _findI - 1;
			_findI = floor((_findL + _findR) / 2);
		} else {
			_findL = _findI;
			_findR = _findI;
			for(; _findR < _len; _findR++) {
				if(_step != _timeline.arrTime[_findR]) {
					break;
				}
			}
			for(; _findL >= 0; _findL--) {
				if(_step != _timeline.arrTime[_findL]) {
					break;
				}
			}
			_findL++;
			
			array_delete(_timeline.arrTime, _findL, _findR - _findL);
			array_delete(_timeline.arrArgs, _findL, _findR - _findL);
			array_delete(_timeline.arrFunc, _findL, _findR - _findL);
			
			if(_findR <= _timeline.moment) {
				_timeline.moment -= _findR - _findL;
			} else if(_findL <= _timeline.moment) {
				_timeline.moment = _findL - 1;
			}
			break;
		}
	}
}

/**
 * 清除时间线上所有时刻
 * @param {struct} _timeline 时间线
 */
function TimelineMomentClearAll(_timeline) {
	array_resize(_timeline.arrTime, 0);
	array_resize(_timeline.arrArgs, 0);
	array_resize(_timeline.arrFunc, 0);
}

/**
 * 返回时间线上最后一个时刻的时间点
 * @param {struct} _timeline 时间线
 * @returns {real} 时间线上最后一个时刻的时间点
 */
function TimelineMaxMoment(_timeline) {
	var _len = array_length(_timeline.arrTime);
	return (_len > 0 ? _timeline.arrTime[_len - 1] : 0);
}

/**
 * 返回时间线上共有多少个时刻
 * @param {struct} _timeline 时间线
 * @returns {real} 时间线上共有多少个时刻
 */
function TimelineSize(_timeline) {
	return array_length(_timeline.arrTime);
}

/**
 * 运行时间线
 * @param {any*} _timeline Description
 * @param {real} _speed 时间线推进的速度，默认为1
 * @param {bool} _loop 是否循环，默认为false
 */
function TimelineRun(_timeline, _speed = 1, _loop = false) {
	var _len = array_length(_timeline.arrTime);
	if(_len <= 0) {
		return;
	}
	
	var _last = _timeline.arrTime[_len - 1];
	
	if(_timeline.time < _last) {
		_timeline.time += _speed;
	} else if(_loop) {
		_timeline.time = 0;
		_timeline.moment = 0;
	}
	
	if(_timeline.moment < _len)
	while(_timeline.moment + 1 < _len && _timeline.time >= _timeline.arrTime[_timeline.moment + 1]) {
		_timeline.moment++;
		
		// _timeline.arrFunc[_timeline.moment](_timeline.arrArgs[_timeline.moment]);
		// 不知道怎么说，反正这部分如果不分成两句的话，对于GM内置函数（如show_debug_message等）就会识别为obj，然后执行起来就会报错
		// 但如果是 function() {} 定义的函数就不会有这种情况发生，怪哦
		// 有兴趣的朋友可以把上面那句取消注释，体验一下
		// 测试版本：IDE v2023.6.0.92, Runtime v2023.6.0.139
		var func = _timeline.arrFunc[_timeline.moment];
		func(_timeline.arrArgs[_timeline.moment]);
		
	}
}
