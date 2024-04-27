extends Area2D


func _physics_process(_delta):
	$Sprite2D.scale = lerp($Sprite2D.scale, Vector2(1, 1), 0.1)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# pointing to sides
		if abs(transform.x.x) > abs(transform.x.y):
			body.velocity.x = -body.velocity.x * 3
			body.velocity.y *= 1.5
		else: # pointing up/down
			body.velocity.y = -body.velocity.y * 2
			body.velocity.x *= 2
		$Sprite2D.scale = Vector2(1.2, 1.4)
		body.x_input_control = 0.1
