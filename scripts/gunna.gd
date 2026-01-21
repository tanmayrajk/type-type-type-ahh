extends Gangsta

var point := Vector2(randf_range(150, 620), randf_range(90, 350))
@export var bullet_scene : PackedScene

var can_shoot = true
var is_shooting := false

func _physics_process(_delta: float) -> void:
	move_to_point()
	move_and_slide()

func move_to_point():
	if is_shooting:
		velocity = Vector2.ZERO
		return

	if player:
		$sprite.flip_h = !(player.global_position.x > global_position.x)
		$weapon_pivot/sprite.flip_v = !(player.global_position.x > global_position.x)
		$weapon_pivot.look_at(player.global_position)
		if global_position.distance_to(point) < 5:
			velocity = Vector2.ZERO
			$sprite.play("idle")
			if can_shoot:
				shoot()
				can_shoot = false
				var timer = get_tree().create_timer(2)
				timer.timeout.connect(func(): can_shoot = true)
			return
		else:
			scale.x = 1
			dir = (point - global_position).normalized()
	else:
		$weapon_pivot.rotation_degrees = 0
		$weapon_pivot/sprite.flip_v = !(dir.x > 0)
		$weapon_pivot.rotation_degrees = 0 if dir.x > 0 else 180
		$sprite.flip_h = !(dir.x > 0)
		pass
		
	$sprite.play("run")
		
	velocity = dir * speed
	
func shoot():
	if is_shooting: return
	
	var available_letters = WordManager.get_available_letters()
	if available_letters.is_empty(): return
	
	is_shooting = true
	
	$animation.play("shoot")
	
	var bullet_word = available_letters.pick_random()
	wm.present_words.append(bullet_word)
	
	var bullet := bullet_scene.instantiate()
	bullet.global_position = $weapon_pivot/muzzle.global_position
	bullet.word = bullet_word
	get_tree().current_scene.add_child(bullet)
	
	is_shooting = false

func _on_area_area_entered(area: Area2D) -> void:
	if (area.is_in_group("bullet") and not area.is_in_group("gang")) and area.target_word == word:
		area.queue_free()
		speed = 0
		var t = get_tree().create_timer(0.1)
		t.timeout.connect(func(): speed = 100)
		if area.is_final_bullet and can_die:
			queue_free()
