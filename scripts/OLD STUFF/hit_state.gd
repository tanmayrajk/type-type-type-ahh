extends State

@export var move_state : State
@export var die_state : State
	
func enter():
	gangsta.velocity = Vector2.ZERO
	knockback()
	if not gangsta.can_die:
		gangsta.sprite.play("hurt")
		await get_tree().create_timer(0.1).timeout
	
	if gangsta.can_die:
		gangsta.state_machine.change_state(die_state)
		return
			
	if gangsta.resume_state == self:
		gangsta.state_machine.change_state(gangsta.state_machine.initial_state)
	
	if gangsta.resume_state:
		gangsta.state_machine.change_state(gangsta.resume_state)
	else:
		gangsta.state_machine.change_state(gangsta.state_machine.initial_state)
		
func knockback():
	if not gangsta.player: return
	var dir = gangsta.global_position - gangsta.player.global_position
	dir = dir.normalized()
	gangsta.velocity = dir * gangsta.knockback_strength
	
