extends Node


func _ready() -> void:
	for n in get_children():
		n.set_volume_linear(Global.volume * n.get_volume_linear())
	
	pass
