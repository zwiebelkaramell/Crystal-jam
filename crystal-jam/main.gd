extends Node3D
var asphalt_scene = preload("res://asphalt.tscn")



func _process(delta: float) -> void:
	
	is_player_hit()
	roadmove()
	
	
	
	pass


func _input(event: InputEvent) -> void:
	pass


# road movement subroutine
func roadmove():
	var road = $Road
	var asphalt_instances = road.get_children()
	var movespeed = 2
	
	road.position.x -= movespeed
	
	for n in asphalt_instances:
		if n.global_position.x <= -200:
			n.queue_free()
			var asphalt = asphalt_scene.instantiate()
			asphalt.position.x = (n.position.x+400)
			road.add_child(asphalt)
			
func is_player_hit():
	var player = $Player
	
	if player.position.z >= 1.0 || player.position.z <= -1.0:
		$UI/HitMask.color += Color(0,0,0,0.01)
	else:
		$UI/HitMask.color -= Color(0,0,0,0.01)
		
	
	
	
