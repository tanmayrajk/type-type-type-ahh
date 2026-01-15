extends Node3D

@export var enemy: PackedScene
var spawn_points: Array[Node3D] = []

func _ready() -> void:
	for child in get_children():
		if child is Node3D:
			spawn_points.append(child)
			
	spawn_enemies()

func _process(delta: float) -> void:
	if len(spawn_points) <= 0:
		return
	
func spawn_enemies():
	for spawn_point in spawn_points:
		var e = enemy.instantiate() as CharacterBody3D
		get_parent().add_child.call_deferred(e)
		e.set_deferred("global_position", spawn_point.global_position)
