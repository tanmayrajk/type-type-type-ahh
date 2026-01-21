class_name GangstaData
extends Resource

@export_enum("runna", "gunna", "splita", "big_steppa")
var name: String
@export_range(0, 100)
var weight: int = 100
@export_group("word weightage")
@export_range(0.0, 1.0)
var min_word_weight: float = 0.0
@export_range(0.0, 1.0)
var max_word_weight: float = 1.0
