extends CharacterBody2D
class_name Gangsta

@export var speed := 100
@export var word_indicator : Control

var word: String
var player: CharacterBody2D

var can_die := false

func _ready() -> void:
	player = find_player()
	word_indicator.caption = word

func _physics_process(_delta: float) -> void:
	move_towards_player()
	
	move_and_slide()

func move_towards_player():
	if not player:
		return
		
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
	
	$sprite.flip_h = !(dir.x > 0)

func find_player():
	return get_tree().get_first_node_in_group("player")
	
func set_caption(pos: int):
	var lhs = word.substr(0, pos)
	var rhs = word.substr(pos, word.length() - pos)
	if not lhs:
		word_indicator.caption = word
		return
	word_indicator.caption = "[color=b13e53]" + lhs + "[/color]" + rhs

func get_hit():
	print("GOT HIT")

func die():
	can_die = true
	word_indicator.hide()
