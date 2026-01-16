extends Node3D


var possible_targets: Array[String] = ["apple", "cat", "dog", "boy", "mathematics", "electronics", "algebra", "handkerchief", "science", "chemistry", "instagram", "youtube", "affirmation"]
#var available_targets: Array[String] = []
var available_targets: Array[Dictionary] = []
var selected_target: Dictionary = {}
var current_pos: int = 0

func _ready() -> void:
	$player.set_main(self)

func _process(delta: float) -> void:
	if selected_target.is_empty():
		return
	#print(selected_target)
	((selected_target.enemy as CharacterBody3D).find_child("body") as Sprite3D).modulate = Color("ff5bff")
	
func get_available_targets():
	return available_targets
