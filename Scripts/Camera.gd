extends Camera

export var amplitude: float = 0.01
export var frequency: float = 1000
export var duration: float = 0.1

var is_shaking = false
var _next_position = Vector2(0, 0)
var _time: float = 0
var _current_amplitude: float
var _current_duration: float
var _current_frequency: float
var _last_postition: Vector2

func _process(delta):
	if is_shaking:
		if (Vector2(h_offset, v_offset) - _next_position).length() < 0.0001:
			print("Changing next position")
			_last_postition = Vector2(_next_position.x, _next_position.y)
			randomize()
			_next_position.x = randf()
			randomize()
			_next_position.y = randf()
			_next_position = _next_position.normalized() * _current_amplitude
		else:
			_time += delta
			var progress = remainder((_time - ceil(_time)), (1 / frequency))
			print(progress)
			h_offset = lerp(_last_postition.x, _next_position.x, progress)
			v_offset = lerp(_last_postition.y, _next_position.y, progress)


func shake(amplitude=self.amplitude, frequency=self.frequency, duration=self.duration, start_new=false):
	if not is_shaking or start_new:
		stop_shaking()
		self._current_amplitude = amplitude
		self._current_duration = duration
		self._current_frequency = frequency
		_time = 0
		is_shaking = true
		yield(get_tree().create_timer(duration), "timeout")
		stop_shaking()
	
func stop_shaking():
	is_shaking = false
	_last_postition = Vector2(0, 0)
	var parent_translation: Vector3 = get_parent().translation
	h_offset = 0
	v_offset = 0

func remainder(from, to):
	while true:
		if from - to > to:
			from -= to
		else:
			return from - to
