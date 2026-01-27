extends GangstaMovement
class_name WanderMovement

var dir = Vector2.ZERO

func get_velocity(_gangsta: Gangsta) -> Vector2:
	if dir == Vector2.ZERO:
		dir = Vector2.from_angle(randf() * TAU)
	
	return dir * speed
