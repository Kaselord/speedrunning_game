extends Node

var time : float = 0.0
var time_until_start : float = 0.0
var should_be_running = false
var min_time : float = 15.0
var gold_time : float = 4.0
var has_won = false
var volume_adder : float = -15
var records = {
	
}
var time_until_menu : float = 0.0
var dead = false
var remember_level_idx : int = 0


func start_time(minimum : float, gold : float):
	has_won = false
	min_time = minimum
	should_be_running = true
	time_until_start = 2.36
	time = 0.0
	gold_time = gold
	$interface/min_time.text = "Maximum: " + str(minimum) + str(".00")
	$interface/gold_time.text = "Star: " + str(gold) + str(".00")
	$start.play()
	$anim.play("start_text")


func _physics_process(delta):
	$music_calm.volume_db = lerp($music_calm.volume_db, 0.0 + volume_adder, 0.1)
	if get_tree().current_scene != null && get_tree().current_scene.is_in_group("level"):
		# do this if we're currently in a level
		$interface/timer_text.show()
		$interface/ColorRect.show()
		$interface/min_time.show()
		$interface/gold_time.show()
		# when we're in gameplay
		if time_until_start <= 0.0:
			$music_intense.volume_db = lerp($music_intense.volume_db, 0.0 + volume_adder, 0.1)
	else:
		$interface/timer_text.hide()
		$interface/ColorRect.hide()
		$interface/min_time.hide()
		$interface/gold_time.hide()
		$music_intense.volume_db = lerp($music_intense.volume_db, -80.0, 0.1)
	$interface/timer_text.text = str(snapped(time, 0.01))
	if should_be_running:
		if time > min_time:
			$lose.play()
			SoundManager.new_sound("res://audio/sfx/out_of_time.ogg")
			text_popup("TIME'S UP!")
			time_until_menu = 2.0
			should_be_running = false
		if time_until_start > 0:
			volume_adder = -15.0
			time_until_start -= delta
		else:
			volume_adder = -5.0
			time += delta
	else:
		volume_adder = -15.0
		if dead:
			time_until_menu = 2.0
			dead = false
		
		if has_won:
			$win.play()
			SoundManager.new_sound("res://audio/sfx/reached_flag.ogg")
			time_until_menu = 2.0
			text_popup("YOU WIN!")
			has_won = false
			if !records.keys().has(get_tree().current_scene.name):
				records[get_tree().current_scene.name] = time
			else:
				if records[get_tree().current_scene.name] > time:
					records[get_tree().current_scene.name] = time
		
		if get_tree().current_scene != null && get_tree().current_scene.is_in_group("level"):
			if time_until_menu <= 0.0:
				time = 0.0
				get_tree().change_scene_to_file("res://scenes/menu.tscn")
			else:
				time_until_menu -= delta
	
	$interface/big_text.scale = lerp($interface/big_text.scale, Vector2(1, 1), 0.2)
	if $interface/big_text.rotation_degrees > 5:
		$interface/big_text.modulate.a = lerp($interface/big_text.modulate.a, 0.0, 0.1)
	$interface/big_text.rotation_degrees = lerp($interface/big_text.rotation_degrees, 10.0, 0.1)
	
	if !$music_calm.playing:
		$music_calm.play(0.0)
		$music_intense.play(0.0)


func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func text_popup(text_to_display : String):
	$interface/big_text.scale = Vector2(0, 0)
	$interface/big_text.modulate.a = 1.0
	$interface/big_text.rotation_degrees = -300
	$interface/big_text.text = text_to_display


func death():
	SoundManager.new_sound("res://audio/sfx/died.ogg")
	text_popup("ur ded")
	$death.play()
	dead = true
	should_be_running = false
