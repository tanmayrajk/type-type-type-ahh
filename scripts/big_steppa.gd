extends Gangsta
class_name TripleShooter

@export var bullet_scene: PackedScene

@export var move_speed := 70
@export var arrive_distance := 6.0
@export var shoot_cooldown := 0.8
@export var hurt_duration := 0.1

@export var roam_min := Vector2(150, 90)
@export var roam_max := Vector2(620, 350)

@export var spread_angle_deg := 12.0

enum State { MOVING, SHOOTING }
var state := State.MOVING

var point: Vector2
var can_shoot := true
var is_hurt := false

func _ready() -> void:
	super._ready()
	speed = move_speed
	pick_new_point()

func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return

	if is_hurt:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	match state:
		State.MOVING:
			move_to_point()
		State.SHOOTING:
			velocity = Vector2.ZERO

	move_and_slide()
	
func pick_new_point() -> void:
	point = Vector2(
		randf_range(roam_min.x, roam_max.x),
		randf_range(roam_min.y, roam_max.y)
	)
	state = State.MOVING


func move_to_point() -> void:
	if global_position.distance_to(point) <= arrive_distance:
		velocity = Vector2.ZERO
		state = State.SHOOTING
		try_shoot()
		return

	dir = (point - global_position).normalized()
	velocity = dir * speed

	if velocity.x != 0:
		$sprite.flip_h = velocity.x < 0
		$sprite.play("run")

func try_shoot() -> void:
	if not can_shoot or not player:
		return

	can_shoot = false
	state = State.SHOOTING
	$sprite.play("shoot")

	shoot_spread()

	get_tree().create_timer(shoot_cooldown).timeout.connect(func():
		if not is_dead:
			can_shoot = true
			pick_new_point()
	)


func shoot_spread() -> void:
	var available_letters = WordManager.get_available_letters().duplicate()
	if available_letters.size() < 3:
		return

	var base_dir := (player.global_position - global_position).normalized()
	var spread := deg_to_rad(spread_angle_deg)
	var angles := [0.0, spread, -spread]

	for angle in angles:
		var idx = randi() % available_letters.size()
		var bullet_word : String = available_letters[idx]
		available_letters.remove_at(idx)

		wm.present_words.append(bullet_word)

		var bullet := bullet_scene.instantiate()
		bullet.global_position = $muzzle.global_position
		bullet.word = bullet_word
		bullet.set_dir(base_dir.rotated(angle))

		get_tree().current_scene.call_deferred("add_child", bullet)

func _on_area_area_entered(area: Area2D) -> void:
	if is_dead:
		return

	if not area.is_in_group("bullet"):
		return
	if area.is_in_group("gang"):
		return
	if area.target_word != word:
		return

	area.queue_free()

	if area.is_final_bullet and can_die:
		die()
	else:
		hurt()


func hurt() -> void:
	if is_hurt:
		return

	is_hurt = true
	$sprite.stop()

	await get_tree().create_timer(hurt_duration).timeout

	if is_dead:
		return

	is_hurt = false
	$sprite.play("run")


func die() -> void:
	if is_dead:
		return

	is_dead = true

	if player:
		shoot_spread()

	queue_free()
