extends Node3D

@export var enemy: PackedScene
var slots: Array[Node3D] = []
var available_slots: Array[Node3D] = []

var manager: Node3D

func _ready() -> void:
	manager = get_parent()
	for child in get_children():
		if child is Node3D:
			slots.append(child)
			available_slots.append(child)
			
	spawn_enemy_with_random_target()
	$Timer.start(randf_range(1, 1.5))
	
func spawn_enemy(target: String) -> CharacterBody3D:
	var rand_slot = available_slots[randi_range(0, available_slots.size() - 1)]
	var e = enemy.instantiate() as CharacterBody3D
	get_parent().add_child.call_deferred(e)
	e.set_deferred("global_position", rand_slot.global_position)
	e.set_target.call_deferred(target)
	e.set_slot.call_deferred(rand_slot)
	available_slots.remove_at(available_slots.find(rand_slot))
	return e

func spawn_enemy_with_random_target():
	if len(manager.possible_targets) <= 0:
		return
	var actually_possible_targets = []
	for t in manager.possible_targets:
		if manager.available_targets.is_empty():
			actually_possible_targets.append(t)
			continue
		
		var exists := false
		for a in manager.available_targets:
			if t[0] == a.target[0]:
				exists = true
				
		if not exists:
			actually_possible_targets.append(t)
			
	if actually_possible_targets.is_empty():
		return
	
	var rand_target = actually_possible_targets[randi_range(0, len(actually_possible_targets as Array[String]) - 1)]
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
	
func add_available_slots(slot: Node3D):
	if slot in slots and slot not in available_slots:
		available_slots.append(slot)

func _on_timer_timeout() -> void:
	var rand_time = randf_range(1, 1.5)
	if len(available_slots) <= 0:
		$Timer.start(rand_time)
		return
	spawn_enemy_with_random_target()
	$Timer.start(rand_time)
