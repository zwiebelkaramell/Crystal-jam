extends Node3D

signal left()
signal right()

@onready var danglers = get_tree().root.get_node("Main/UI/Danglers")

func _ready() -> void:
	
	pass


func _process(delta: float) -> void:
	
	var movedir = Vector3.ZERO
	
	if Input.is_action_pressed("left"):
		movedir += Vector3(0,0,-1)
		danglers.force(Vector2((980*delta),(-245*delta)))
		left.emit()
	
	if Input.is_action_pressed("right"):
		movedir += Vector3(0,0,1)
		danglers.force(Vector2(-(980*delta),(-245*delta)))
		right.emit()
	
	self.position += movedir * Global.move_speed
	pass
	
