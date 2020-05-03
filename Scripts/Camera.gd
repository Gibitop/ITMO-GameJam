extends Camera

export var amplitude: float = 1
export var frequency: float = 10
export var duration: float = 0.1

var is_shaking = false
var _next_position: Vector2 
var _time: float = 0
var _current_amplitude: float
var _current_duration: float
var _current_frequency: float
var _last_postition: Vector2
var _current_time = 0

func _process(delta):
	if is_shaking:
		if _time > duration:
			stop_shaking()
		else:
			_time += delta

		if _current_time * frequency > 1:
			_last_postition = Vector2(_next_position.x, _next_position.y)
			randomize()
			_next_position.x = randf()
			randomize()
			_next_position.y = randf()
			_next_position = _next_position.normalized() * _current_amplitude
			_current_time = 0
		else:
			_current_time += delta
			var progress = _current_time * frequency
			h_offset = lerp(_last_postition.x, _next_position.x, progress)
			v_offset = lerp(_last_postition.y, _next_position.y, progress)


func shake(amplitude=self.amplitude, frequency=self.frequency, duration=self.duration, start_new=false):
	if not is_shaking or start_new:
		stop_shaking()
		self._current_amplitude = amplitude
		self._current_duration = duration
		self._current_frequency = frequency
		_current_time = 1 / _current_frequency + 1
		is_shaking = true


func stop_shaking():
	is_shaking = false
	h_offset = 0
	v_offset = 0
