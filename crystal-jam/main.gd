extends Node3D
var asphalt_scene = preload("res://asphalt.tscn")
var object_scene = preload("res://object.tscn")
var og = {}
var reset_wheel: bool
var coin_velocity: Vector2

@onready var cam = $Player/Camera3D
@onready var tims = $UI/"Timmy's"
@onready var coins = $UI/Coins


func _ready() -> void:
	
	#assign og position values to all ui elements for jiggle purposes
	for n in $UI.get_children():
		og.set(n.get_name(), n.get_position())


func _process(delta: float) -> void:
	
	is_player_hit()
	roadmove()
	do_crystals()
	UI_gubbins(delta)
	
	pass


func _input(event: InputEvent) -> void:
	pass


# road movement subroutine
func roadmove():
	var road = $Road
	var asphalt_parent = $Road/Asphalt
	var asphalt_instances = asphalt_parent.get_children()
	var movespeed = 2
	
	road.position.x -= movespeed
	
	for n in asphalt_instances:
		if n.global_position.x <= -200:
			n.queue_free()
			var asphalt = asphalt_scene.instantiate()
			asphalt.position.x = (n.position.x+400)
			asphalt_parent.add_child(asphalt)
			
func is_player_hit():
	var player = $Player
	
	if player.position.z >= 1.0 || player.position.z <= -1.0:
		$UI/HitMask.color += Color(0,0,0,0.01)
	else:
		$UI/HitMask.color -= Color(0,0,0,0.01)
		

func do_crystals():
	var spawn_distance = 200
	var crystal_parent = $Road/Crystals
	var active_crystals = crystal_parent.get_children()
	var rel_pos = $Road.get_position()
	
	for n in active_crystals:
		if n.global_position.x <= -200:
			n.queue_free()
			
	if crystal_parent.get_children().size() < 3:
		var crystal = object_scene.instantiate()
		crystal.position.x = (-rel_pos.x) + randf_range(spawn_distance, spawn_distance+800)
		crystal.position.z = (-rel_pos.z) + randf_range(-1,1)
		crystal_parent.add_child(crystal)
		
func UI_gubbins(delta):
	
	####### Wheel Vibration #################
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(0), 0.1))
	if reset_wheel:
		wheel.set_position(og["Wheel"])
	if wheel.get_rotation() > 1 or wheel.get_rotation() < -1:
		if Engine.get_frames_drawn() % 2 == 0:
			var newpos = wheel.get_position() + Vector2(randf_range(-15,15), randf_range(-15,15))
			wheel.set_position(newpos)
			reset_wheel = true
		else:
			reset_wheel = false
	#########################################
	
	######## Camera Tilt ###################

	
	cam.set_rotation(Vector3(0,0,(move_toward(cam.get_rotation().z, 0, (0.2*ease(abs(cam.get_rotation().z),1.5))))))
	
	########################################
	
	####### Tim's Rattle ##########
	
	tims.set_rotation(move_toward(tims.get_rotation(), 0, (0.2*ease(abs(tims.get_rotation()), 1.1))))
	
	###############################
	
	####### Coin Jiggle #########
	var coin_pos = coins.get_position()
	var desired_pos = (Vector2(move_toward((coin_pos.x), (coin_pos.x+coin_velocity.x), 1),
		move_toward((coin_pos.y), (coin_pos.y+coin_velocity.y), 1)
	))
	coins.set_position(desired_pos.limit_length(10))
	coin_velocity = Vector2(move_toward(coin_velocity.x, 0, 5), move_toward(coin_velocity.y, 0, 5))
	#############################
	
func _on_player_hit(area: Area3D) -> void:
	pass # Replace with function body.


func _on_player_left() -> void:
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(-90), 0.2))
	cam.set_rotation(Vector3(0,0,(move_toward(cam.get_rotation().z, 0.5, 0.02))))
	tims.set_rotation(move_toward(tims.get_rotation(), -0.1, 0.3))
	coin_velocity += Vector2(-10, (randf_range(-0.005, 0.005)+randf_range(-0.005, 0.005)))
	pass


func _on_player_right() -> void:
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(90), 0.2))
	cam.set_rotation(Vector3(0,0,(move_toward(cam.get_rotation().z, -0.5, 0.02))))
	tims.set_rotation(move_toward(tims.get_rotation(), 0.1, 0.3))
	coin_velocity += Vector2(10, (randf_range(-0.005, 0.005)+randf_range(-0.005, 0.005)))
	pass
