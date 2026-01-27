extends GangstaMovement
class_name RandomPointMovement

@export var arrive_distance := 8.0

func get_velocity(gangsta: Gangsta) -> Vector2:
	var g = gangsta
	if not g.has_target:
		#print("NOOO")
		g.target_point = get_random_point(g.x_extents, g.y_extents)
		g.has_target = true
		g.arrived = false
		
	var dist : Vector2 = g.target_point - g.global_position
	
	if dist.length() <= arrive_distance:
		g.has_target = false
		g.arrived = true
		return Vector2.ZERO
		
	return dist.normalized() * gangsta.speed

func get_random_point(x_extents: Array[float], y_extents: Array[float]) -> Vector2:
	if x_extents.size() < 2 or y_extents.size() < 2:
		return Vector2(randf_range(0, DisplayServer.window_get_size().x), randf_range(0, DisplayServer.window_get_size().y))
	else:
		return Vector2(randf_range(x_extents[0], x_extents[1]), randf_range(y_extents[0], y_extents[1]))
