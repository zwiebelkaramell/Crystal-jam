extends AudioStreamPlayer

func _ready() -> void:
	self.set_volume_linear(Global.volume)
	pass
