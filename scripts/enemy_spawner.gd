extends Node3D

@export var enemy: PackedScene
var spawn_points: Array[Node3D] = []

var manager: Node3D

func _ready() -> void:
	manager = get_parent()
	for child in get_children():
		if child is Node3D:
			spawn_points.append(child)
			
	spawn_enemy_with_random_target()
	$Timer.start()

func _process(delta: float) -> void:
	if len(spawn_points) <= 0:
		return
	
func spawn_enemy(target: String) -> CharacterBody3D:
	var rand_spawn = spawn_points[randi_range(0, len(spawn_points) - 1)]
	var e = enemy.instantiate() as CharacterBody3D
	get_parent().add_child.call_deferred(e)
	e.set_deferred("global_position", rand_spawn.global_position)
	e.set_target.call_deferred(target)
	return e

func spawn_enemy_with_random_target():
	if len(manager.possible_targets) <= 0:
		return
	var rand_target = manager.possible_targets[randi_range(0, len(manager.possible_targets as Array[String]) - 1)]
	var e = spawn_enemy(rand_target)
	var i = (manager.possible_targets as Array[String]).find(rand_target)
	manager.available_targets.append({
		"target": rand_target,
		"enemy": e
	})
	manager.possible_targets.remove_at(i)
	#print(manager.available_targets)
	var available_targets = []
	for target in manager.available_targets:
		available_targets.append(target.target)
	print(available_targets)

func _on_timer_timeout() -> void:
	spawn_enemy_with_random_target()
	$Timer.start()
