extends Area2D

@export var speed := 900.0
var target_word: String
var is_final_bullet := false

func _physics_process(delta: float) -> void:
	var dir = Vector2.RIGHT.rotated(rotation)
	position += dir * speed * delta
