extends CharacterBody3D

var alpha_keys: Array[int] = []

var main: Node3D

func set_main(main_ref):
	main = main_ref
	_on_main_ready()
	
func _on_main_ready():
	print(main)
	print(main.available_targets)

func _ready():
	for code in range(KEY_A, KEY_Z + 1):
		alpha_keys.append(code)
		
	print(alpha_keys)
	
func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.is_pressed():
		return
	if event.keycode not in alpha_keys:
		return
	if not main:
		return
	#print((event as InputEventKey).as_text_key_label())
	var found := false
	if not main.selected_target:
		for target in main.available_targets:
			if (target[0] as String).to_upper() == (event as InputEventKey).as_text_key_label():
				main.selected_target = main.available_targets[(main.available_targets as Array).find(target)]
				main.current_pos = 1
				print([main.selected_target, main.current_pos])
				found = true
		if not found:
			print("NO TARGETS AVAILABLE!")
	else:
		if main.selected_target[main.current_pos].to_upper() == event.as_text_key_label():
			if main.current_pos != (main.selected_target as String).length() - 1:
				main.current_pos += 1
				print([main.selected_target, main.current_pos])
			else:
				var i = (main.available_targets as Array[String]).find(main.selected_target as String)
				if i != -1:
					print([main.selected_target, main.selected_target.length()])
					print("TARGET " + main.selected_target.to_upper() + " DESTROYED!")
					(main.available_targets as Array[String]).remove_at(i)
					main.selected_target = ""
					main.current_pos = 0
		else:
			print("ERROR!")
