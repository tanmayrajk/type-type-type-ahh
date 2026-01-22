extends Node2D
class_name Generator

var wm = WordManager

@export var gang: Array[GangData]
@export var spawn_points: Array[Node2D] = []

@export var wave_data: Array[SpawnData]

@export var initial_gang_count : int = 4
@export_range(1, 10)
var count_increment_min := 1
@export_range(1, 10)
var count_increment_max := 4

var current_wave = 1
var current_rate: Array[CurrentRateData]
var current_gang_count = initial_gang_count

var is_wave_running = false
var wave_start_queued = false

func end_wave():
	current_gang_count += randi_range(count_increment_min, count_increment_max)
	current_wave += 1
	for i in range(wave_data.size()):
		if wave_data[i].name == current_rate[i].name:
			current_rate[i].rate = wave_data[i].increment
	is_wave_running = false

func start_wave():
	is_wave_running = true
	print(current_wave)
	for i in range(current_gang_count):
		spawn_gangsta()
		await get_tree().create_timer(1).timeout
	end_wave()

func _ready() -> void:
	for i in range(wave_data.size()):
		var cr = CurrentRateData.new()
		cr.name = wave_data[i].name
		cr.rate = wave_data[i].initial_rate
		current_rate.append(cr)
	wm.data_processed.connect(func():
		start_wave())
		
func _process(_delta: float) -> void:
	var present_gang = get_parent().get_children().filter(func(c): return c.is_in_group("gang"))
	if not is_wave_running and not wave_start_queued and present_gang.size() == 0:
		wave_start_queued = true
		await get_tree().create_timer(2).timeout
		start_wave()
		wave_start_queued = false
		
#func _on_spawn_timer_timeout() -> void:
	#spawn_gangsta()
	#timer.start(2)
	
func get_random_spawn_point() -> Node2D:
	return spawn_points.pick_random()

func pick_random_gang_weighted():	
	var total_weight := 0.0
	for g in current_rate:
		total_weight += g.rate
	
	if total_weight <= 0:
		return null
		
	var r := randf() * total_weight
	
	var acc := 0.0
	for i in range(gang.size()):
		acc += current_rate[i].rate
		if r <= acc:
			return gang[i]

func spawn_gangsta():
	var gangsta = pick_random_gang_weighted()
	var gangsta_scene = gangsta.scene.instantiate()
	var word = wm.get_random_weighted_word(gangsta.data.min_word_weight, gangsta.data.max_word_weight)
	if not word:
		gangsta_scene.queue_free()
		return
	gangsta_scene.word = word
	wm.present_words.append(word)
	(gangsta_scene as CharacterBody2D).global_position = get_random_spawn_point().global_position
	get_tree().current_scene.call_deferred("add_child", gangsta_scene)
	gangsta_scene.add_to_group("gang")
	
