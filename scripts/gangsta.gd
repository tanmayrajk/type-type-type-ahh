extends CharacterBody2D
class_name Gangsta

@export var data: GangstaData
@export var speed := 100
@export var word_indicator : Control

var word: String
var player: CharacterBody2D
var dir: Vector2 = Vector2.ZERO
var can_die := false

var wm = WordManager

func _ready() -> void:
	player = find_player()
	dir = Vector2.from_angle(randf() * TAU)
	word_indicator.caption = word.to_lower()
	
	wm.word_advanced.connect(func(w, pos):
		if word == w:
			set_caption(pos))
			
	wm.word_finished.connect(func(w):
		if word == w:
			set_caption(w.length() - 1)
			die())

func _physics_process(_delta: float) -> void:
	move_towards_player()
	
	move_and_slide()

func move_towards_player():
	if player:
		dir = (player.global_position - global_position).normalized()
	else:
		pass
		
	velocity = dir * speed
	
	$sprite.flip_h = !(dir.x > 0)

func find_player():
	return get_tree().get_first_node_in_group("player")
	
func set_caption(pos: int):
	var lhs = word.substr(0, pos)
	var rhs = word.substr(pos, word.length() - pos)
	if not lhs:
		word_indicator.caption = word.to_lower()
		return
	word_indicator.caption = "[color=b13e53]" + lhs + "[/color]" + rhs
	word_indicator.z_index = 6

func get_hit():
	print("GOT HIT")

func die():
	can_die = true
	word_indicator.hide()
