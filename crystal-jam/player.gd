extends Node3D
var move_speed = 0.01

func _process(delta: float) -> void:
	
	var movedir = Vector3.ZERO
	
	if Input.is_action_pressed("left"):
		movedir += Vector3(0,0,-1)
	
	if Input.is_action_pressed("right"):
		movedir += Vector3(0,0,1)
	
	self.position += movedir * move_speed
	pass
	
