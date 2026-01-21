class_name GangData
extends Resource

@export var scene: PackedScene
@export_enum("runna", "gunna", "splita", "big_steppa")
var name: String
@export_range(0, 100)
var weight: int = 100
