extends CanvasLayer

@onready var og_wheel_pos = $Wheel.get_position() 

func _process(delta: float) -> void:
	$Label.text = str(Global.health)
	pass
