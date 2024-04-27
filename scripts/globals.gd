extends Node

var time : float = 0.0
var time_until_start : float = 0.0
var should_be_running = false
var min_time : float = 15.0
var gold_time : float = 4.0
var has_won = false


func start_time(minimum : float, gold : float):
	has_won = false
	min_time = minimum
	gold_time = gold
	should_be_running = true
	time_until_start = 2.36
	$start.play()


func _physics_process(delta):
	$interface/timer_text.text = str(snapped(time, 0.01))
	if should_be_running:
		if time > min_time:
			$lose.play()
			should_be_running = false
		if time_until_start > 0:
			time_until_start -= delta
		else:
			time += delta
	else:
		if has_won:
			$win.play()
			has_won = false
