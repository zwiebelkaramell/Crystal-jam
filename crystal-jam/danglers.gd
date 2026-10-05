extends Node


@onready var heart = $Heart
@onready var dice = $Dice
@onready var dline = $Diceline
@onready var hline = $Heartline
@onready var mirror = $Anchor.get_position()
@onready var control = $"Bez Control Point".get_position()

var length = 150

func _ready() -> void:
	dline.set_point_position(0, mirror)
	hline.set_point_position(0, mirror)
	
func _process(delta: float) -> void:
	
	dangle(dice, length, mirror, 100, delta)
	dangle(heart, length, mirror, 100, delta)
	
	#dice.apply_force((anchor + (dice.get_position()-anchor).limit_length(100)))
	#heart.position = anchor + (heart.get_position()-anchor).limit_length(100)
	
	rope(hline, heart, control)
	rope(dline, dice, control)
	
	
	
func dangle(obj: RigidBody2D, len: int, anchor: Vector2, elasticity: float, delta: float): # keeps an object dangling from the mirror
	var pos = obj.get_position()
	var limit = (pos-anchor).limit_length(len)
	
	if abs(pos.x) > abs(limit.x) || abs(pos.y) > abs(limit.y):
		obj.apply_force(elasticity*-((pos-anchor)-limit), Vector2(0, -1))
	
	#obj.apply_torque(-(1000*(lerp_angle(obj.get_rotation(), 0, ease(obj.get_rotation()/PI, 0.2)))))
	
	pass
	
func rope(line: Line2D, dangler: RigidBody2D, c_point: Vector2): #call every frame, makes the ropes move properly
	#point attatched to the dice
	line.set_point_position(line.points.size()-1, dangler.position)
	
	var seg_len = 1.0/line.points.size()
	var end = line.points[line.points.size()-1]
	
	
	#do the rest of the points
	for n in range(1, line.points.size()-1):
		var point = line.points[n]
		var t = seg_len*n
		
		#make your own bezier function cuz godot's are confusing
		var l0 = lerp(mirror, c_point, t)
		var l1 = lerp(c_point, end, t)
		var bez = lerp(l0, l1, t)


		line.set_point_position(n, bez)
	
func force(vec: Vector2):
	heart.apply_central_impulse(vec)
	dice.apply_central_impulse(vec)
	pass
