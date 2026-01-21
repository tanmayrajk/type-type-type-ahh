extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var health: int = 100

var wm = WordManager
var gs = GameState

func _ready() -> void:
	wm.word_advanced.connect(func(w, _pos):
		shoot(w, false))
	wm.word_finished.connect(func(w):
		shoot(w, true))
	gs.player_died.connect(func(): die())

func _process(_delta: float) -> void:
	if not wm.selected_word:
		var closest
		var closest_distance := INF
		for child in get_parent().get_children():
			if child.is_in_group("gang"):
				var dist = global_position.distance_squared_to(child.global_position)
				if dist < closest_distance:
					closest_distance = dist
					closest = child
		if not closest:
			($weapon_pivot as Node2D).rotation_degrees = 0
			return
		if closest.global_position.x < global_position.x:
			scale.x = -1
		else:
			scale.x = 1
		$weapon_pivot.look_at(closest.global_position)
	else:
		for child in get_parent().get_children():
			if child.is_in_group("gang"):
				if child.word == wm.selected_word:
					if child.global_position.x < global_position.x:
						scale.x = -1
					else:
						scale.x = 1
					$weapon_pivot.look_at(child.global_position)
			if not child:
				($weapon_pivot as Node2D).rotation_degrees = 0
				return
				
func shoot(word: String, is_final_bullet := false):
	$animation.play("shoot")
	var bullet := bullet_scene.instantiate()
	bullet.global_position = $weapon_pivot/muzzle.global_position
	bullet.target_word = word
	bullet.is_final_bullet = is_final_bullet
	get_tree().current_scene.add_child(bullet)
	
func die():
	queue_free()

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("gang"):
		gs.damage_player(100)

func _on_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("gang") and area.is_in_group("bullet"):
		gs.damage_player(100)
