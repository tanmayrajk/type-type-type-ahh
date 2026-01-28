extends State

@export var looping := false
@export var move_state : State
@export var bullet_scene : PackedScene

var has_shot := false

func enter():
	has_shot = false
	gangsta.sprite.play("shoot")

func physics_update(_delta):
	if not gangsta.player and gangsta.state_machine.current_state == self:
		gangsta.state_machine.change_state(gangsta.move_state)
		return
		
	if not has_shot:
		shoot()
		has_shot = true

		if not looping:
			gangsta.state_machine.change_state(move_state)
		else:
			get_tree().create_timer(1.5).timeout.connect(func(): has_shot = false)

	if not looping:
		gangsta.state_machine.change_state(move_state)

func shoot():
	var available_letters = wm.get_available_letters()
	if available_letters.is_empty(): return
	
	#$animation.play("shoot")
	
	var bullet_word = available_letters.pick_random()
	wm.present_words.append(bullet_word)
	
	var bullet := bullet_scene.instantiate()
	bullet.word = bullet_word
	bullet.global_position = gangsta.muzzle.global_position
	get_tree().current_scene.add_child(bullet)
