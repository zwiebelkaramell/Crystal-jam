extends Node


@onready var heart = $Heart
@onready var dice = $Dice
@onready var dline = $Diceline
@onready var hline = $Heartline
@onready var mirror = $Anchor.get_position()

var length = 150

func _ready() -> void:
	dline.set_point_position(0, mirror)
	hline.set_point_position(0, mirror)
	
func _process(delta: float) -> void:
	
	dangle(dice, length, mirror, 100, delta)
	dangle(heart, length, mirror, 100, delta)
	
	#dice.apply_force((anchor + (dice.get_position()-anchor).limit_length(100)))
	#heart.position = anchor + (heart.get_position()-anchor).limit_length(100)
	
	dline.set_point_position(dline.points.size()-1, dice.position)
	hline.set_point_position(hline.points.size()-1, heart.position)
	
func dangle(obj: RigidBody2D, len: int, anchor: Vector2, elasticity: float, delta: float): # keeps an object dangling from the mirror
	var pos = obj.get_position()
	var limit = (pos-anchor).limit_length(len)
	
	if abs(pos.x) > abs(limit.x) || abs(pos.y) > abs(limit.y):
		obj.apply_force(elasticity*-((pos-anchor)-limit), Vector2(0, -1))
	
	#obj.apply_torque(-(1000*(lerp_angle(obj.get_rotation(), 0, ease(obj.get_rotation()/PI, 0.2)))))
	
	pass
	
func force(vec: Vector2):
	heart.apply_central_impulse(vec)
	dice.apply_central_impulse(vec)
	pass
