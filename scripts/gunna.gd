extends Gangsta

@onready var muzzle := $gun_pivot/muzzle

@export var shoot_state : State
@export var move_state : State
@export var x_extents : Array[float]
@export var y_extents: Array[float]

var facing_dir := 1
var target_point: Vector2 = Vector2.ZERO
var has_target := false
var arrived := false

func set_facing_dir_from_velocity():
	if velocity.x != 0:
		facing_dir = sign(velocity.x)
	
	if velocity.x == 0 and state_machine.current_state == shoot_state and player:
		facing_dir = 1 if player.global_position.x > global_position.x else -1
		
	$sprite.flip_h = facing_dir < 0
	
	if state_machine.current_state != shoot_state:
		$gun_pivot.rotation_degrees = 0 if facing_dir > 0 else 180
		if (facing_dir > 0 and sign($gun_pivot/sprite.scale.y) < 0) or (facing_dir < 0 and sign($gun_pivot/sprite.scale.y) > 0):
			$gun_pivot/sprite.scale.y *= -1
	else:
		if player:
			$gun_pivot.look_at(player.global_position)
			
	#if not player and not is_dead and state_machine.current_state != move_state:
		#state_machine.change_state(move_state)

func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	set_facing_dir_from_velocity()
