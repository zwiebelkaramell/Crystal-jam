extends Node3D
var asphalt_scene = preload("res://asphalt.tscn")
var object_scene = preload("res://object.tscn")


func _process(delta: float) -> void:
	
	is_player_hit()
	roadmove()
	do_crystals()
	
	
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
		print(n.global_position.x)
		if n.global_position.x <= -200:
			n.queue_free()
			
	if crystal_parent.get_children().size() < 3:
		print("spawning")
		var crystal = object_scene.instantiate()
		crystal.position.x = (-rel_pos.x) + randf_range(spawn_distance, spawn_distance+800)
		crystal.position.z = (-rel_pos.z) + randf_range(-1,1)
		crystal_parent.add_child(crystal)


func _on_player_hit(area: Area3D) -> void:
	pass # Replace with function body.
