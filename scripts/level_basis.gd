extends Node2D

@export var minimum_time : float = 15.0
@export var gold_time : float = 5.0


func _ready():
	Globals.start_time(minimum_time, gold_time)
