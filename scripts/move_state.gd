extends State

@export var looping := false

func enter():
	print("hi")
	gangsta.sprite.play("move")
	
func physics_update(_delta):
	var v = gangsta.alive_movement.get_velocity(gangsta) if gangsta.player else gangsta.dead_movement.get_velocity(gangsta)
	gangsta.velocity = v
	gangsta.move_and_slide()
	
	if gangsta.player and gangsta.alive_movement is RandomPointMovement and gangsta.arrived and gangsta.state_machine.current_state != gangsta.shoot_state:
		if looping:
			gangsta.has_target = false
		else:
			gangsta.state_machine.change_state(gangsta.shoot_state)
