extends Gangsta

var point := Vector2(randf_range(150, 620), randf_range(90, 350))
@export var bullet_scene : PackedScene

var can_shoot := true
var is_shooting := false
var shooting_interrupted := false
var force_final_shot := false

var gs = GameState

func _process(_delta: float) -> void:
	if is_dead:
		$collider.disabled = true
		$area/collider.disabled = true

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
	if is_shooting and not force_final_shot: return
	
	var available_letters = WordManager.get_available_letters()
	if available_letters.size() < 3: return
	
	is_shooting = true
	shooting_interrupted = false
	
	if not can_die and not force_final_shot:
		$sprite.stop()
		$sprite.play("shoot")
		await $sprite.animation_finished
		if shooting_interrupted and not force_final_shot:
			is_shooting = false
			return
	
	var base_dir = Vector2.DOWN
	var angles = [0, PI/4, -PI/4]
	for angle in angles:
		var bullet_word = available_letters.pick_random()
		wm.present_words.append(bullet_word)
		var bullet := bullet_scene.instantiate()
		bullet.global_position = $muzzle.global_position
		bullet.word = bullet_word
		bullet.set_dir(base_dir.rotated(angle))
		get_tree().current_scene.call_deferred("add_child", bullet)
	
	is_shooting = false
	
func _on_area_area_entered(area: Area2D) -> void:
	if is_dead: return
	if (area.is_in_group("bullet") and not area.is_in_group("gang")) and area.target_word == word:
		area.queue_free()
		speed = 0
		var t = get_tree().create_timer(0.1)
		t.timeout.connect(func(): speed = 100)
		if area.is_final_bullet and can_die:
			print("HUHHH")
			gs.increment_score(data.score)
			#$sprite.stop()
			#$sprite.play("die")
			#await $sprite.animation_finished
			is_dead = true
			if is_shooting:
				shooting_interrupted = true
				$sprite.stop()
			force_final_shot = true
			await shoot()
			force_final_shot = false
			#var a = $dead_sprite.duplicate()
			#a.global_position = $sprite.global_position
			#get_parent().add_child(a)
			#if $sprite.flip_h or scale.x == -1:
				#a.flip_h = true
			#a.visible = true
			#$sprite.visible = false
			call_deferred("queue_free")
			
#func death():
	#if is_dead: return
	#is_
