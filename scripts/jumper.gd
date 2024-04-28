extends Area2D


func _physics_process(_delta):
	$Sprite2D.scale = lerp($Sprite2D.scale, Vector2(1, 1), 0.1)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.velocity = transform.x * 500.0
		body.can_dash = true
		body.is_dashing = 0
		body.jump_has_been_released = true
		$Sprite2D.scale = Vector2(1.2, 1.4)
		body.x_input_control = 0.1
