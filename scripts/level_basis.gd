extends Node2D

@export var minimum_time : float = 15.0
@export var gold_time : float = 4.0


func _ready():
	add_to_group("level")
	Globals.start_time(minimum_time, gold_time)
