extends Node

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if $Node.get_modulate().a < 1:
		$Node.modulate += Color(0,0,0,0.01)
	pass

func _on_button_pressed() -> void:
	Global.health = 3
	get_tree().change_scene_to_file("res://main.tscn")
	pass
