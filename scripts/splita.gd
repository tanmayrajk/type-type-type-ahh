extends Gangsta
class_name Splita

@export var runna_scene: PackedScene
@export var runna_res: GangstaData

@export var hurt_duration := 0.1

var is_hurt := false
var gs := GameState


func _ready() -> void:
	super._ready()

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

	speed = 100
	is_hurt = false


func die() -> void:
	if is_dead:
		return

	is_dead = true
	speed = 0
	velocity = Vector2.ZERO

	gs.increment_score(data.score)

	if has_node("area/collider"):
		$area/collider.set_deferred("disabled", true)
	if has_node("collider"):
		$collider.set_deferred("disabled", true)

	$sprite.play("die")


func _on_sprite_animation_finished() -> void:
	if not is_dead or $sprite.animation != "die":
		return

	spawn_runnas()
	queue_free()

func spawn_runnas() -> void:
	var available_letters = wm.get_available_letters()
	if available_letters.size() < 2:
		return

	var spawn_points = $spawn_points.get_children()
	if spawn_points.size() < 2:
		return

	for point in spawn_points:
		var runna := runna_scene.instantiate()

		var runna_word = wm.get_random_weighted_word(
			runna_res.min_word_weight,
			runna_res.max_word_weight
		)

		runna.word = runna_word
		wm.present_words.append(runna_word)

		runna.global_position = point.global_position
		runna.add_to_group("gang")

		get_tree().current_scene.add_child(runna)
