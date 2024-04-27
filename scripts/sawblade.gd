extends Area2D


func _physics_process(_delta):
	if Globals.should_be_running:
		$Sprite2D.rotation_degrees += 30.0


func _on_body_entered(body):
	if body.is_in_group("player"):
		Globals.death()
