extends Area2D

@export var speed := 900.0
var target_word: String
var is_final_bullet := false

func _physics_process(delta: float) -> void:
	var gang = get_tree().get_nodes_in_group("gang")
	var gangsta = gang.filter(func(g): return g.word == target_word)[0]
	var dir = (gangsta.global_position - global_position).normalized()
	position += dir * speed * delta
