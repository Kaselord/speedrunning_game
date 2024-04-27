extends Node2D

@export var display_name : String = "Tutorial"
@export var level_id : String = "000"
@export var gold_time : float = 4.0
@export var to_unlock : NodePath
@export var unlocked = false
@export var scene_to_load_path : String
var best_time : float = -1

func _ready():
	if Globals.records.keys().has(level_id):
		best_time = Globals.records[level_id]
		unlocked = true
		if get_node_or_null(to_unlock) != null:
			get_node(to_unlock).unlocked = true
		
		if best_time < gold_time:
			$gold.show()
		else:
			$gold.hide()
	else:
		$gold.hide()

func _process(_delta):
	if unlocked:
		$ColorRect.color = Color("f8f8c2")
	else:
		$ColorRect.color = Color("83b49f")
	$level_name.text = display_name
	if best_time > 0:
		$time.text = str(snapped(best_time, 0.01))
	else:
		$time.text = ""
