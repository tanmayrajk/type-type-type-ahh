extends Gangsta

@export var bullet_scene: PackedScene

# Movement / positioning
var point := Vector2(randf_range(150, 620), randf_range(90, 350))

# Shooting
var can_shoot := true
var is_shooting := false

# Hurt / knockback
var is_hurt := false

var gs := GameState


func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return

	if is_hurt:
		move_and_slide()
		return

	move_to_point()
	move_and_slide()


func move_to_point() -> void:
	if is_shooting:
		velocity = Vector2.ZERO
		return

	if not player:
		return

	# Reached destination → idle + shoot
	if global_position.distance_to(point) < 5:
		velocity = Vector2.ZERO

		var facing_right := player.global_position.x > global_position.x
		$sprite.flip_h = not facing_right
		$weapon_pivot/sprite.flip_v = not facing_right
		$weapon_pivot.look_at(player.global_position)

		if not is_hurt and not is_shooting:
			$sprite.play("idle")

		if can_shoot:
			shoot()
			can_shoot = false
			get_tree().create_timer(2.0).timeout.connect(func():
				if not is_dead:
					can_shoot = true
			)
		return

	# Moving
	dir = (point - global_position).normalized()
	velocity = dir * speed

	$sprite.flip_h = not (dir.x > 0)
	$weapon_pivot.rotation_degrees = 0 if dir.x > 0 else 180
	$weapon_pivot/sprite.flip_v = not (dir.x > 0)

	if not is_hurt:
		$sprite.play("run")


func shoot() -> void:
	if is_shooting or is_dead:
		return

	var available_letters = WordManager.get_available_letters()
	if available_letters.is_empty():
		return

	is_shooting = true
	$sprite.play("idle")

	var bullet_word = available_letters.pick_random()
	wm.present_words.append(bullet_word)

	var bullet := bullet_scene.instantiate()
	bullet.global_position = $weapon_pivot/muzzle.global_position
	bullet.word = bullet_word
	get_tree().current_scene.add_child(bullet)

	# Shooting lock
	get_tree().create_timer(0.25).timeout.connect(func():
		if not is_dead:
			is_shooting = false
	)


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

	# FINAL HIT → DIE (ONLY FADE IN THE ENTIRE SCRIPT)
	if area.is_final_bullet and can_die:
		is_dead = true
		speed = 0
		velocity = Vector2.ZERO

		$sprite.play("die")
		gs.increment_score(data.score)

		get_tree().create_timer(5).timeout.connect(func():
				var tween := get_tree().create_tween()
				tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
				tween.finished.connect(queue_free)
				)
		return

	is_hurt = true
	speed = 0

	$sprite.play("hurt")

	# End hurt after short stun
	get_tree().create_timer(0.15).timeout.connect(func():
		if is_dead:
			return

		is_hurt = false
		speed = 100

		if velocity.length() > 0:
			$sprite.play("run")
		else:
			$sprite.play("idle")
	)
