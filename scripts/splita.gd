extends Gangsta

@export var runna_scene: PackedScene

func _on_sprite_animation_finished() -> void:
	for point in $spawn_points.get_children():
		var runna = runna_scene.instantiate()
		var runna_word = get_tree().get_first_node_in_group("generator").get_random_caption()
		runna.word = runna_word
		get_parent().present_words.append(runna_word)
		(runna as CharacterBody2D).global_position = point.global_position
		get_tree().current_scene.call_deferred("add_child", runna)
		runna.add_to_group("gang")
	queue_free()


func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet") and area.target_word == word:
		area.queue_free()
		speed = 0
		var t = get_tree().create_timer(0.1)
		t.timeout.connect(func(): speed = 100)
		if area.is_final_bullet:
			$sprite.play("break")
