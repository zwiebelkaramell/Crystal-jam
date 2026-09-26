extends Node3D
var asphalt_scene = preload("res://asphalt.tscn")
var object_scene = preload("res://object.tscn")
var reset_wheel
@onready var og_wheel_pos = $UI/Wheel.position


func _process(delta: float) -> void:
	
	is_player_hit()
	roadmove()
	do_crystals()
	UI_gubbins()
	
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
		
func UI_gubbins():
	
	####### Wheel Vibration #################
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(0), 0.1))
	if reset_wheel:
		wheel.set_position(og_wheel_pos)
	if wheel.get_rotation() > 1 or wheel.get_rotation() < -1:
		if Engine.get_frames_drawn() % 2 == 0:
			var newpos = wheel.get_position() + Vector2(randf_range(-15,15), randf_range(-15,15))
			wheel.set_position(newpos)
			reset_wheel = true
		else:
			reset_wheel = false
	#########################################
	
func _on_player_hit(area: Area3D) -> void:
	pass # Replace with function body.


func _on_player_left() -> void:
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(-90), 0.2))
	pass


func _on_player_right() -> void:
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(90), 0.2))
	pass
