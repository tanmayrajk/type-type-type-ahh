extends Node2D

var present_words: Array[String] = []

var selected_word: String
var current_pos: int

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.is_pressed():
		return
	
	if not selected_word:
		for word in present_words:
			if word[0].to_lower() == (event as InputEventKey).as_text_key_label().to_lower():
				selected_word = word
				current_pos = 1
				update_caption(current_pos)
				print([selected_word, current_pos])
				return
	else:
		if selected_word[current_pos].to_lower() == (event as InputEventKey).as_text_key_label().to_lower():
			if current_pos == (len(selected_word) - 1):
				current_pos += 1
				update_caption(current_pos)
				print([selected_word, current_pos])
				slime_gansta(selected_word)
				selected_word = ""
				current_pos = 0
			else:
				current_pos += 1
				update_caption(current_pos)
				print([selected_word, current_pos])
		else:
			print("wrong sequence")
			
func update_caption(pos: int):
	for child in get_children():
		if not child.is_in_group("gang"):
			continue
		if child.word.to_lower() == selected_word.to_lower():
			child.set_caption(current_pos)
			
func slime_gansta(word: String):
	for child in get_children():
		print(child.name)
		if not child.is_in_group("gang"):
			continue
		if child.word.to_lower() == selected_word.to_lower():
			child.call_deferred("queue_free")
