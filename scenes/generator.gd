extends Node2D

@export var gang: Array[PackedScene] = []
@export var spawn_points: Array[Node2D] = []
@onready var timer = $spawn_timer

@export var file: JSON

func get_random_spawn_point() -> Node2D:
	var rand_index = randi_range(0, spawn_points.size() - 1)
	return spawn_points[rand_index]
	
func spawn_gangsta():
	var rand_gangsta_index = randi_range(0, gang.size() - 1)
	var gangsta = gang[rand_gangsta_index].instantiate()
	gangsta.caption = file.data.words[randi_range(0, file.data.words.size() - 1)]
	(gangsta as CharacterBody2D).global_position = get_random_spawn_point().global_position
	get_parent().call_deferred("add_child", gangsta)
	
func _ready() -> void:
	timer.stop()
	timer.one_shot = true
	timer.autostart = false
	spawn_gangsta()
	timer.start()
	#print(file.data.words[0])

func _on_spawn_timer_timeout() -> void:
	spawn_gangsta()
	timer.start(2)
