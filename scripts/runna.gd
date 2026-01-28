extends Gangsta
class_name Runna

@export var hurt_duration := 0.1
@export var move_speed := 100

var is_hurt := false

func _ready() -> void:
	super._ready()
	speed = move_speed


func _on_area_area_entered(area: Area2D) -> void:
	if is_dead:
		return

	if not area.is_in_group("bullet"):
		return
	if area.is_in_group("gang"):
		return
	if area.target_word != word:
		return

	area.queue_free()

	if area.is_final_bullet and can_die:
		die()
	else:
		hurt()


func hurt() -> void:
	if is_hurt:
		return

	is_hurt = true
	speed = 0

	await get_tree().create_timer(hurt_duration).timeout

	if is_dead:
		return

	speed = move_speed
	is_hurt = false


func die() -> void:
	is_dead = true
	queue_free()
