extends Node

signal data_processed
signal word_selected(word: String)
signal word_advanced(word: String, pos: int)
signal word_finished(word: String)

var data : Array[String] = []

var present_words: Array[String] = []
var selected_word := ""
var current_pos: int

func set_data(arr: Array):
	data = index_data(arr.filter(func(a): return typeof(a) == TYPE_STRING))
	emit_signal("data_processed")

func index_data(arr: Array):
	var indexed: Array[String] = []
	for a in arr:
		if a is String:
			indexed.append(a)
			
	indexed.sort_custom(func(a: String, b: String):
		return a.length() < b.length())
	indexed = indexed.filter(func(w): return w.strip_edges().length() > 0)
	return indexed
	
func get_random_weighted_word(min_weightage: float = 0.0, max_weightage: float = 1.0):
	var max_possible_length = data[data.size() - 1].length()
	var max_length = max_weightage * max_possible_length
	var min_length = min_weightage * max_possible_length
	var filtered_data = data.filter(func(d):
		return d.length() >= min_length and d.length() <= max_length)
	
	if present_words.is_empty():
		return filtered_data.pick_random()
		
	var used_letters = get_used_letters()
			
	var possible_words: Array[String] = []
	for word in filtered_data:
		if word[0].to_lower() not in used_letters:
			possible_words.append(word)
			
	return "" if possible_words.is_empty() else possible_words.pick_random()
	
func get_used_letters():
	var used_letters: Array[String] = []
	for word in present_words:
		if word[0].to_lower() not in used_letters:
			used_letters.append(word[0])
	return used_letters
	
func get_available_letters():
	var used_letters = get_used_letters()
	var available_letters := range(26).map(func(i):
		return String.chr(97 + i)).filter(func(c):
			return not used_letters.has(c))
	return available_letters

func select_word(word: String):
	if not present_words.has(word): return
	if selected_word: return
	if current_pos > 0: return
	
	selected_word = word
	current_pos = 0
	emit_signal("word_selected", word)
	advance_word()
	
func advance_word():
	if not selected_word: return
	current_pos += 1
	if current_pos == selected_word.length() or selected_word.length() == 1:
		emit_signal("word_finished", selected_word)
		present_words.erase(selected_word)
		current_pos = 0
		selected_word = ""
	else:
		emit_signal("word_advanced", selected_word, current_pos)
