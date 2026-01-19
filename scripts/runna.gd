extends CharacterBody2D

@export var speed := 100.0

var player: CharacterBody2D
var caption: String

func _ready() -> void:
	call_deferred("find_player")
	$word_indicator.caption = caption
	
func find_player():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if not player:
		return
	
func _physics_process(_delta: float) -> void:
	if not player:
		return
		
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
	
	$sprite.flip_h = !(dir.x > 0)
	
	move_and_slide()
