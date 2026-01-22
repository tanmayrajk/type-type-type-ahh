class_name SpawnData
extends Resource

@export_enum("runna", "gunna", "splita", "big_steppa")
var name: String
@export_range(0, 1)
var initial_rate: float = 1
@export_range(0, 1)
var increment: float = 1
@export_range(0, 1)
var min_rate: float = 0
@export_range(0, 1)
var max_rate: float = 1
