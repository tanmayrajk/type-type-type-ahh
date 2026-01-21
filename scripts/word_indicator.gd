extends Control

var caption = "caption"

func _process(_delta: float) -> void:
	$MarginContainer/MarginContainer/RichTextLabel.text = caption
