extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		$"head rotation point".rotate(0.1)
	elif event.is_action_pressed("right"):
		$"head rotation point".rotate(-0.1)
