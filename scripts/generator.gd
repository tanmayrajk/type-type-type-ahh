extends Node2D

@export var gang: Array[PackedScene] = []
@export var spawn_points: Array[Node2D] = []
@onready var timer = $spawn_timer

@export var file: JSON

func get_random_spawn_point() -> Node2D:
	return spawn_points.pick_random()
	
func get_used_letters():
	var present_words: Array[String] = get_parent().present_words
	var words: Array = file.data.words
		
	var used_letters: Array[String] = []
	for word in present_words:
		if word[0].to_lower() not in used_letters:
			used_letters.append(word[0])
			
	return used_letters
	
func get_random_caption() -> String:
	var present_words: Array[String] = get_parent().present_words
	var words: Array = file.data.words
	
	if present_words.is_empty():
		return words.pick_random()
		
	var used_letters = get_used_letters()
			
	var possible_words: Array[String] = []
	for word in words:
		if word[0].to_lower() not in used_letters:
			possible_words.append(word)
			
	return "" if possible_words.is_empty() else possible_words.pick_random()
	
func spawn_gangsta(gangsta_index: int = -1):
	var gangsta
	if gangsta_index >= 0 and gangsta_index <= (gang.size() - 1):
		gangsta = gang[gangsta_index].instantiate()
	else:
		gangsta = gang.pick_random().instantiate()
	var word = get_random_caption()
	if not word:
		gangsta.queue_free()
		return
	gangsta.word = word
	get_parent().present_words.append(word)
	(gangsta as CharacterBody2D).global_position = get_random_spawn_point().global_position
	get_tree().current_scene.call_deferred("add_child", gangsta)
	gangsta.add_to_group("gang")
	
func _ready() -> void:
	timer.stop()
	timer.one_shot = true
	timer.autostart = false
	#spawn_gangsta()
	timer.start(1)
	#print(file.data.words[0])

func _on_spawn_timer_timeout() -> void:
	spawn_gangsta()
	timer.start(2)
