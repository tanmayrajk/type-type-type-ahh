extends Control

var caption = "caption"

func _process(delta: float) -> void:
	$MarginContainer/MarginContainer/RichTextLabel.text = caption
