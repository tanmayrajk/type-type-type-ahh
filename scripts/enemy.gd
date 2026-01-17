extends CharacterBody3D

@export var speed = 5.0
@export var min_dist = 10.0
var can_move := true

@onready var target_label := $SubViewport/Control/RichTextLabel
var target: String

var slot: Node3D

func _ready() -> void:
	$"move timer".start()

func _physics_process(delta: float) -> void:
	var player = get_tree().current_scene.find_child("player")
	
	#print(global_position.distance_to(player.global_position))
	if global_position.distance_to(player.global_position) <= min_dist:
		#$AnimationPlayer.play("attack")
		can_move = false
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	var direction = (player.global_position - global_position)
	
	direction.y = 0
	direction = direction.normalized()
	
	if can_move:
		$AnimationPlayer.play("run")
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		$AnimationPlayer.play("idle")
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()

func _process(delta: float) -> void:
	var main = get_parent()
	
	if not main:
		return
		
	if target and not main.selected_target.is_empty() and target == main.selected_target.target:
		var completed_part = target.substr(0, main.current_pos)
		var left_part = target.substr(main.current_pos, len(target) - main.current_pos)
		$SubViewport/Control/RichTextLabel.text = "[color=red]" + completed_part + "[/color]" + left_part
		return
	
	$SubViewport/Control/RichTextLabel.text = target

func set_target(t: String):
	#print(target_label)
	target = t
	$SubViewport/Control/RichTextLabel.text = target
	
func set_slot(s: Node3D):
	slot = s
	
func _on_move_timer_timeout() -> void:
	can_move = false
	$"stop timer".start()

func _on_stop_timer_timeout() -> void:
	can_move = true
	$"move timer".start()


func _on_tree_exiting() -> void:
	var enemy_spawner = get_tree().current_scene.find_child("enemy_spawner")
	enemy_spawner.add_available_slots(slot)
