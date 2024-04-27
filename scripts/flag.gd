extends Area2D

var time : float = 0.0

func _physics_process(delta):
	if Globals.should_be_running:
		time += delta
		for point_idx in $thing.get_point_count():
			if point_idx > 1:
				$thing.points[point_idx].y =  sin(time * 3 + float(point_idx) * 0.4) * 2


func _on_body_entered(body):
	if body.is_in_group("player"):
		Globals.should_be_running = false
		Globals.has_won = true
