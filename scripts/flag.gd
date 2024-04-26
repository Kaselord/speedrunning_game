extends Area2D

var time : float = 0.0

func _physics_process(delta):
	time += delta
	for point_idx in $thing.get_point_count():
		if point_idx > 1:
			$thing.points[point_idx].y =  sin(time * 3 + float(point_idx) * 0.4) * 2
