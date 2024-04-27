extends Node

var time : float = 0.0
var time_until_start : float = 0.0
var should_be_running = false
var min_time : float = 15.0
var has_won = false
var volume_adder : float = -10
var records = {
	
}


func start_time(minimum : float):
	has_won = false
	min_time = minimum
	should_be_running = true
	time_until_start = 2.36
	$start.play()
	$anim.play("start_text")


func _physics_process(delta):
	$music_calm.volume_db = lerp($music_calm.volume_db, 0.0 + volume_adder, 0.1)
	if get_tree().current_scene.is_in_group("level"):
		$interface/timer_text.show()
		$interface/ColorRect.show()
		if time_until_start <= 0.0:
			$music_intense.volume_db = lerp($music_intense.volume_db, 0.0 + volume_adder, 0.1)
	else:
		$interface/timer_text.hide()
		$interface/ColorRect.hide()
		$music_intense.volume_db = lerp($music_intense.volume_db, -80.0, 0.1)
	$interface/timer_text.text = str(snapped(time, 0.01))
	if should_be_running:
		if time > min_time:
			$lose.play()
			text_popup("TIME'S UP!")
			should_be_running = false
		if time_until_start > 0:
			volume_adder = -10.0
			time_until_start -= delta
		else:
			volume_adder = 0.0
			time += delta
	else:
		volume_adder = -10.0
		if has_won:
			$win.play()
			text_popup("YOU WIN!")
			has_won = false
			records[get_tree().current_scene.name] = time
	
	$interface/big_text.scale = lerp($interface/big_text.scale, Vector2(1, 1), 0.2)
	if $interface/big_text.rotation_degrees > 5:
		$interface/big_text.modulate.a = lerp($interface/big_text.modulate.a, 0.0, 0.1)
	$interface/big_text.rotation_degrees = lerp($interface/big_text.rotation_degrees, 10.0, 0.1)
	
	if !$music_calm.playing:
		$music_calm.play(0.0)
		$music_intense.play(0.0)


func text_popup(text_to_display : String):
	$interface/big_text.scale = Vector2(0, 0)
	$interface/big_text.modulate.a = 1.0
	$interface/big_text.rotation_degrees = -300
	$interface/big_text.text = text_to_display
