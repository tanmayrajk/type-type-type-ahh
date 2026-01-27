extends GangstaMovement
class_name ChaseMovement

func get_velocity(gangsta: Gangsta) -> Vector2:
	return (gangsta.player.global_position - gangsta.global_position).normalized() * speed
