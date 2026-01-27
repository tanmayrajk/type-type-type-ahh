extends Gangsta

var facing_dir := 1

func set_facing_dir_from_velocity():
	if velocity.x != 0:
		facing_dir = sign(velocity.x)
		$sprite.flip_h = facing_dir < 0

func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	set_facing_dir_from_velocity()
