extends Node2D
class_name Generator

@export var gang: Array[GangData]
@export var spawn_points: Array[Node2D] = []
@onready var timer = $spawn_timer

@export var file: JSON

var wm = WordManager

func _ready() -> void:
	wm.set_data(file.data.words)
	timer.stop()
	timer.one_shot = true
	timer.autostart = false
	timer.start(1)
	
func _on_spawn_timer_timeout() -> void:
	spawn_gangsta()
	timer.start(2)
	
func get_random_spawn_point() -> Node2D:
	return spawn_points.pick_random()

func pick_random_gang_weighted():	
	var totaL_weight := 0
	for g in gang:
		totaL_weight += g.data.weight
	
	if totaL_weight <= 0:
		return null
		
	var r := randf() * totaL_weight
	
	var acc := 0.0
	for g in gang:
		acc += g.data.weight
		if r <= acc:
			return g

func spawn_gangsta():
	var gangsta = pick_random_gang_weighted()
	var gangsta_scene = gangsta.scene.instantiate()
	var word = wm.get_random_weighted_word(gangsta.data.min_word_weight, gangsta.data.max_word_weight)
	if not word:
		gangsta_scene.queue_free()
		return
	gangsta_scene.word = word
	wm.present_words.append(word)
	(gangsta_scene as CharacterBody2D).global_position = get_random_spawn_point().global_position
	get_tree().current_scene.call_deferred("add_child", gangsta_scene)
	gangsta_scene.add_to_group("gang")
	
