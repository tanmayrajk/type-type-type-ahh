extends Gangsta

var gs := GameState

func _process(_delta: float) -> void:
	if is_dead:
		$area/collider.set_deferred("disabled", true)
		$collider.set_deferred("disabled", true)

func _on_area_area_entered(area: Area2D) -> void:
	if is_dead: return
	
	if (area.is_in_group("bullet") and not area.is_in_group("gang")) and area.target_word == word:
		area.queue_free()
		
		if area.is_final_bullet and can_die:
			$sprite.stop()
			is_dead = true
			$sprite.play("die")
			gs.increment_score(data.score)
			get_tree().create_timer(5).timeout.connect(func():
				var tween := get_tree().create_tween()
				tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
				tween.finished.connect(queue_free)
				)
			return
		
		$sprite.play("hurt")
		speed = 0
		var t = get_tree().create_timer(0.1)
		t.timeout.connect(func():
			if is_dead: return
			speed = 100
			$sprite.play("run")
			)
