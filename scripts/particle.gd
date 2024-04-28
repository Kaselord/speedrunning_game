extends Node2D

var time : float = 0.0
var lifetime : float = 1.0
var starting_scale : float = 1.0
var end_scale : float = 0.0
var starting_alpha : float = 1.0
var end_alpha : float = 0.0
var velocity = Vector2(0, 0)
var starting_velocity = Vector2(0, 0)
var end_velocity = Vector2(0, 0)


func _physics_process(delta):
	if time > lifetime:
		call_deferred("free")
	
	$sprite.scale = lerp(Vector2(starting_scale, starting_scale), Vector2(end_scale, end_scale), time / lifetime)
	$sprite.modulate.a = lerp(starting_alpha, end_alpha, time / lifetime)
	velocity = lerp(starting_velocity, end_velocity, time / lifetime)
	position += velocity * delta
	
	time += delta
