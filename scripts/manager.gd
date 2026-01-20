extends Node2D

var present_words: Array[String] = []

var selected_word: String
var current_pos: int

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.is_pressed():
		return
		
	var key = (event as InputEventKey).as_text_key_label().to_lower()
	if key.length() != 1:
		return
		
	var player = get_children().filter(func(c): return c.is_in_group("player"))[0]
	
	if not selected_word:
		for word in present_words:
			if word[0].to_lower() == key:
				selected_word = word
				current_pos = 1
				update_caption(current_pos)
				player.shoot()
				return
	else:
		if selected_word[current_pos].to_lower() == key:
			if current_pos == (len(selected_word) - 1):
				current_pos += 1
				update_caption(current_pos)
				slime_gansta(selected_word)
				present_words.remove_at(present_words.find(selected_word))
				player.shoot(true)
				selected_word = ""
				current_pos = 0
			else:
				current_pos += 1
				update_caption(current_pos)
				player.shoot()
			
func update_caption(pos: int):
	for child in get_children():
		if child.is_in_group("gang") and child.word.to_lower() == selected_word.to_lower():
			child.set_caption(pos)
			
func slime_gansta(word: String):
	for child in get_children():
		if child.is_in_group("gang") and child.word.to_lower() == word.to_lower():
			child.die()
