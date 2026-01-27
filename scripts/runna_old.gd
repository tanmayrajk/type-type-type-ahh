extends Gangsta

var gs = GameState

func _process(_delta: float) -> void:
	if is_dead:
		$area/collider.disabled = true
		$collider.disabled = true

func _on_area_area_entered(area: Area2D) -> void:
	if (area.is_in_group("bullet") and not area.is_in_group("gang")) and area.target_word == word:
		area.queue_free()
		speed = 0
		var t = get_tree().create_timer(0.1)
		t.timeout.connect(func(): speed = 100)
		if area.is_final_bullet and can_die:
			$sprite.stop()
			is_dead = true
			$sprite.play("die")
			gs.increment_score(data.score)


func _on_sprite_animation_finished() -> void:
	var a = $dead_sprite.duplicate()
	a.global_position = $sprite.global_position
	get_parent().add_child(a)
	if $sprite.flip_h or scale.x == -1:
		a.flip_h = true
	a.visible = true
	$sprite.visible = false
	queue_free()
