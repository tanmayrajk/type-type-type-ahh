extends CharacterBody3D

@export var speed = 5.0
var can_move := true

func _ready() -> void:
	$"move timer".start()

func _physics_process(delta: float) -> void:
	var player = get_tree().current_scene.find_child("player")
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	var direction = (player.global_position - global_position)
	direction.y = 0
	direction = direction.normalized()
	
	if can_move:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
	
	
func _on_move_timer_timeout() -> void:
	can_move = false
	$"stop timer".start()


func _on_stop_timer_timeout() -> void:
	can_move = true
	$"move timer".start()
