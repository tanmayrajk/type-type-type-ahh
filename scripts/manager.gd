extends Node3D

var available_targets: Array[String] = ["apple", "cat"]
var selected_target: String = ""
var current_pos: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.set_main(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_available_targets():
	return available_targets
