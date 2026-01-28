extends Node2D
class_name StateMachine

@export var initial_state: State
var current_state: State

func init(gangsta):
	for child in get_children():
		child.gangsta = gangsta
	change_state(initial_state)
	
func change_state(new_state: State):
	if current_state == new_state:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
	
func update(delta):
	if current_state:
		current_state.update(delta)
		
func physics_update(delta):
	if current_state:
		current_state.physics_update(delta)
