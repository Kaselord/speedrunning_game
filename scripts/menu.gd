extends Node2D

var selection_idx : int = 0


func _process(_delta):
	if Input.is_action_just_pressed("left"):
		selection_idx = clamp(selection_idx - 1, 0, 4)
	if Input.is_action_just_pressed("right"):
		selection_idx = clamp(selection_idx + 1, 0, 4)
	
	var selected_level = $levels.get_child(selection_idx)
	
	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file(selected_level.scene_to_load_path)
	
	$arrow.position.x = lerp($arrow.position.x, 55.0 + float(selection_idx) * 100.0, 0.2)
