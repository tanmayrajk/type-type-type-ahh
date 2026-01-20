extends Gangsta

var point := Vector2(randf_range(150, 620), randf_range(200, 550))
@export var bullet_scene : PackedScene

var can_shoot := true
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
		$sprite.flip_h = !(dir.x > 0)
		pass
		
	$sprite.play("run")
		
	velocity = dir * speed
	
func shoot():
	if is_shooting: return
	
	var used_letters = get_tree().get_first_node_in_group("generator").get_used_letters()
	var available_letters := range(26).map(func(i):
		return String.chr(97 + i)).filter(func(c):
			return not used_letters.has(c))
	
	if available_letters.size() < 3: return
	
	is_shooting = true
	
	$sprite.stop()
	$sprite.play("shoot")
	await $sprite.animation_finished
	
	var base_dir = Vector2.DOWN
	var angles = [0, PI/4, -PI/4]
	for angle in angles:
		var bullet_word = available_letters.pick_random()
		get_tree().current_scene.present_words.append(bullet_word)
		var bullet := bullet_scene.instantiate()
		bullet.global_position = $muzzle.global_position
		bullet.word = bullet_word
		bullet.set_dir(base_dir.rotated(angle))
		get_tree().current_scene.add_child(bullet)
	
	is_shooting = false
	
func _on_area_area_entered(area: Area2D) -> void:
	if (area.is_in_group("bullet") and not area.is_in_group("gang")) and area.target_word == word:
		area.queue_free()
		speed = 0
		var t = get_tree().create_timer(0.1)
		t.timeout.connect(func(): speed = 100)
		if area.is_final_bullet:
			queue_free()
