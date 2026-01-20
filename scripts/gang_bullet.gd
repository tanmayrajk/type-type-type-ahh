extends Area2D

@export var speed := 200.0
var word: String

func _process(_delta: float) -> void:
	$word_indicator.caption = word

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		get_tree().current_scene.present_words.remove_at(get_tree().current_scene.present_words.find(word))
		queue_free()
		return
	var dir = (player.global_position - global_position).normalized()
	position += dir * speed * delta
	
func set_caption(_pos: int = 1):
	$word_indicator.caption = "[color=b13e53]" + word + "[/color]"

func _on_area_area_entered(area: Area2D) -> void:
	#print(area.target_word)
	if (area.is_in_group("bullet") and not area.is_in_group("gang")) and area.target_word == word:
		area.queue_free()
		if area.is_final_bullet:
			queue_free()
