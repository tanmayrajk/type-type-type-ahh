extends Gangsta
class_name Gunna

@export var bullet_scene: PackedScene

@export var move_speed := 80
@export var hurt_duration := 0.1
@export var shoot_interval := 1.5
@export var arrive_distance := 6.0

@export var roam_min := Vector2(150, 90)
@export var roam_max := Vector2(620, 350)

enum State { MOVING, SHOOTING }
var state := State.MOVING
var prev_state := State.MOVING

var point: Vector2
var can_shoot := true
var is_hurt := false


func _ready() -> void:
	super._ready()
	speed = move_speed
	pick_point()


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
			if velocity.x != 0:
				face_direction_x(velocity.x)
			update_gun_for_movement()

		State.SHOOTING:
			velocity = Vector2.ZERO
			face_player()
			update_gun_for_shooting()

			if not $sprite.is_playing() or $sprite.animation != "shoot":
				$sprite.play("shoot")



	move_and_slide()
	
func pick_point() -> void:
	point = Vector2(
		randf_range(roam_min.x, roam_max.x),
		randf_range(roam_min.y, roam_max.y)
	)
	state = State.MOVING


func move_to_point() -> void:
	if global_position.distance_to(point) <= arrive_distance:
		velocity = Vector2.ZERO
		state = State.SHOOTING
		return

	dir = (point - global_position).normalized()
	velocity = dir * speed

func _process(_delta: float) -> void:
	if is_dead or is_hurt:
		return

	if state == State.SHOOTING and can_shoot:
		shoot()


func shoot() -> void:
	if not player or not bullet_scene:
		return

	can_shoot = false
	
	var available_letters = WordManager.get_available_letters()
	if available_letters.is_empty():
		return
	
	var bullet_word = available_letters.pick_random()
	wm.present_words.append(bullet_word)

	var bullet := bullet_scene.instantiate()
	bullet.global_position = $weapon_pivot/muzzle.global_position
	bullet.word = bullet_word
	get_tree().current_scene.add_child(bullet)

	get_tree().create_timer(shoot_interval).timeout.connect(func():
		if not is_dead:
			can_shoot = true
	)

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
		dead()
	else:
		hurt()


func hurt() -> void:
	if is_hurt:
		return

	is_hurt = true
	prev_state = state
	state = State.MOVING
	speed = 0
	velocity = Vector2.ZERO

	$sprite.stop()

	await get_tree().create_timer(hurt_duration).timeout

	if is_dead:
		return

	speed = move_speed
	state = prev_state
	is_hurt = false

	if state == State.MOVING:
		$sprite.play("run")
	elif state == State.SHOOTING:
		$sprite.play("shoot")


func dead() -> void:
	if is_dead:
		return
	is_dead = true
	queue_free()

func face_direction_x(x: float) -> void:
	if x == 0:
		return
	$sprite.flip_h = x < 0


func face_player() -> void:
	if not player:
		return
	face_direction_x(player.global_position.x - global_position.x)
	
func update_gun_for_movement() -> void:
	if $sprite.flip_h:
		$weapon_pivot.rotation_degrees = 180
		$weapon_pivot/sprite.flip_v = true
	else:
		$weapon_pivot.rotation_degrees = 0
		$weapon_pivot/sprite.flip_v = false


func update_gun_for_shooting() -> void:
	if not player:
		return

	$weapon_pivot.look_at(player.global_position)
	$weapon_pivot/sprite.flip_v = $sprite.flip_h
