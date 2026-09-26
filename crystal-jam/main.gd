extends Node3D
var asphalt_scene = preload("res://asphalt.tscn")



func _process(delta: float) -> void:
	
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
			for x in asphalt_instances:
				print(x)
			print("break")
			var asphalt = asphalt_scene.instantiate()
			asphalt.position.x = (n.position.x+400)
			road.add_child(asphalt)
			
		
