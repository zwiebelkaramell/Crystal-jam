extends Node3D
var left_tex = load("res://Assets/Art/crystal1.png")
var right_tex = load("res://Assets/Art/crystal2.png")
var rainbow_tex = load("res://Assets/Art/crystal3.png")

var types = ["left", "right", "rainbow"]
var type

func _process(delta: float) -> void:
	if type == "rainbow":
		do_rainbow($sprite)

func _ready() -> void:
	self.type = types[randi_range(0, 2)]

	match type:
		"left":
			$sprite.set_texture(left_tex)
		"right":
			$sprite.set_texture(right_tex)
		"rainbow":
			$sprite.set_texture(rainbow_tex)


func do_rainbow(sprite: Node):
	var frequency = .05
	var offset = 2
	var height = 2
	var shift = 1
	
	var color = Color(((sin(frequency*Engine.get_frames_drawn())*height)+shift),
		((sin(frequency*Engine.get_frames_drawn()+offset)*height)+shift),
		((sin(frequency*Engine.get_frames_drawn()+(offset*2))*height)+shift),
		1
		)
		
	sprite.set_modulate(color)
