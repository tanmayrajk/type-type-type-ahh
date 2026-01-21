extends Node2D

var wm = WordManager

func _ready() -> void:
	randomize()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.is_pressed():
		return
		
	var key = (event as InputEventKey).as_text_key_label().to_lower()
	if key.length() != 1:
		return
		
	if wm.selected_word:
		if not wm.selected_word[wm.current_pos].to_lower() == key:
			return
		wm.advance_word()
	else:
		var target_words = wm.present_words.filter(func(w): return w[0].to_lower() == key)
		if target_words.is_empty(): return
		wm.select_word(target_words[0])
