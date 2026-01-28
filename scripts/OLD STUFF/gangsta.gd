extends CharacterBody2D
class_name GangstaOld

@onready var state_machine: StateMachine = $state_machine
@onready var sprite: AnimatedSprite2D = $sprite
@onready var word_indicator: Control = $word_indicator
@onready var area: Area2D = $area

var player: CharacterBody2D
var wm := WordManager
var gs := GameState
var word: String
var can_die := false
var is_dead := false
var resume_state : State

@export var alive_movement: GangstaMovement
@export var dead_movement: GangstaMovement

@export var speed := 100
@export var hit_state : State
@export var colliders: Array[CollisionShape2D]
@export var data: GangstaData
@export var knockback_strength := 1000.0

func _ready() -> void:
	player = find_player()
	word_indicator.caption = word.to_lower()
	
	wm.word_advanced.connect(func(w, pos):
		if word == w:
			set_caption(pos))
			
	wm.word_finished.connect(func(w):
		if word == w:
			set_caption(w.length())
			word_indicator.hide())
			
	area.area_entered.connect(func(a): on_bullet_hit(a))
			
	state_machine.init(self)
	
func _process(delta: float) -> void:
	state_machine.update(delta)
	
func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)
	
func find_player():
	return get_tree().get_first_node_in_group("player")
	
func set_caption(pos: int):
	var lhs = word.substr(0, pos)
	var rhs = word.substr(pos, word.length() - pos)
	if not lhs:
		word_indicator.caption = word.to_lower()
		return
	word_indicator.caption = "[color=b13e53]" + lhs + "[/color]" + rhs
	word_indicator.z_index = 6
	
	
func on_bullet_hit(a: Area2D):
	if not a.is_in_group("bullet"): return
	if a.is_in_group("gang"): return
	if a.target_word != word: return
	
	resume_state = state_machine.current_state
	
	if a.is_final_bullet:
		can_die = true
		gs.increment_score(data.score)
		
	a.queue_free()
	state_machine.change_state(hit_state)
