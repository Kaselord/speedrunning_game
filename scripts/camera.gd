extends Camera2D

@export var follow_path : NodePath


func _physics_process(_delta):
	var follow = get_node_or_null(follow_path)
	if follow != null:
		position = lerp(position, follow.position, 0.4)
