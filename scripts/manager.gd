extends Node3D


var possible_targets: Array[String] = ["apple", "cat", "dog", "boy", "mathematics", "electronics", "algebra", "handkerchief", "science", "chemistry", "instagram", "youtube", "affirmation"]
#var available_targets: Array[String] = []
var available_targets: Array[Dictionary] = []
var selected_target: Dictionary = {}
var current_pos: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.set_main(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_available_targets():
	return available_targets
