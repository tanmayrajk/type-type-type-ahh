extends Node2D

@export var gang: Array[PackedScene] = []
@export var spawn_points: Array[Node2D] = []
@onready var timer = $spawn_timer

@export var file: JSON

func get_random_spawn_point() -> Node2D:
	return spawn_points.pick_random()
	
func get_random_caption() -> String:
	var present_words: Array[String] = get_parent().present_words
	var words: Array = file.data.words
	
	if present_words.is_empty():
		return words.pick_random()
		
	var used_letters: Array[String] = []
	for word in present_words:
		if word[0].to_lower() not in used_letters:
			used_letters.append(word[0])
			
	var possible_words: Array[String] = []
	for word in words:
		if word[0].to_lower() not in used_letters:
			possible_words.append(word)
			
	return possible_words.pick_random()
	
func spawn_gangsta():
	var gangsta = gang.pick_random().instantiate()
	var word = get_random_caption()
	gangsta.word = word
	get_parent().present_words.append(word)
	(gangsta as CharacterBody2D).global_position = get_random_spawn_point().global_position
	get_parent().call_deferred("add_child", gangsta)
	gangsta.add_to_group("gang")
	
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
