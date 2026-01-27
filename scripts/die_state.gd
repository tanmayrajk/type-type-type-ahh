extends State

func enter():
	disable_colliders()
	hide_gun()
	gangsta.sprite.play("die")
	await gangsta.sprite.animation_finished
	print("hi lol")
	gangsta.is_dead = true
	
func disable_colliders():
	for c in gangsta.colliders:
		c.set_deferred("disabled", true)
		
func hide_gun():
	var gun_sprite = gangsta.get_node_or_null("gun_pivot/sprite")
	if gun_sprite: gun_sprite.hide()
