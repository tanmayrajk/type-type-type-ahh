extends Area2D

@export var speed := 200.0
@export var score := 50
var word: String

var dir: Vector2
var is_dir_set := false

var can_die := false

var player: CharacterBody2D

var wm = WordManager
var gs = GameState

func _ready() -> void:
	$visibility.screen_exited.connect(func():
		wm.present_words.erase(word)
		queue_free(), CONNECT_ONE_SHOT)
		
	wm.word_advanced.connect(func(w, _pos):
		if word == w:
			set_caption())
			
	wm.word_finished.connect(func(w):
		if word == w:
			die())
			
	player = find_player()

func _process(_delta: float) -> void:
	$word_indicator.caption = word

func _physics_process(delta: float) -> void:
	if not player:
		wm.present_words.erase(word)
		queue_free()
		return
	if not is_dir_set:
		dir = (player.global_position - global_position).normalized()
	position += dir * speed * delta
	
func set_dir(dir_vector: Vector2):
	dir = dir_vector
	is_dir_set = true
	
func set_caption(_pos: int = 1):
	$word_indicator.caption = "[color=b13e53]" + word + "[/color]"

func _on_area_area_entered(area: Area2D) -> void:
	if ((area.is_in_group("bullet") and not area.is_in_group("gang"))) and area.target_word == word and area.is_final_bullet and can_die:
		gs.increment_score(score)
		area.queue_free()
		queue_free()

func find_player():
	return get_tree().get_first_node_in_group("player")

func die():
	can_die = true
