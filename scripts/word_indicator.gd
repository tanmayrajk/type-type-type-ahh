extends Control

var caption = "caption"

func _process(delta: float) -> void:
	$MarginContainer/MarginContainer/RichTextLabel.text = caption
	#$MarginContainer/MarginContainer/RichTextLabel.reset_size()
	#$MarginContainer/MarginContainer/RichTextLabel.custom_minimum_size = Vector2.ZERO
	#$MarginContainer/MarginContainer.queue_sort()
	#$MarginContainer.queue_sort()
