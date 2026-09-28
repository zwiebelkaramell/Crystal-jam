extends Node3D
var asphalt_scene = preload("res://asphalt.tscn")
var object_scene = preload("res://object.tscn")
var og = {}
var reset_wheel: bool
var coin_velocity: Vector2
var mon_knockback = 0

@onready var cam = $Player/Camera3D
@onready var tims = $UI/"Timmy's"
@onready var coins = $UI/Coins
@onready var rearview = $UI/ViewPort/SubViewport/Node3D
@onready var baddie = $Baddie
@onready var player = $Player

func _ready() -> void:
	
	#assign og position values to all ui elements for jiggle purposes
	for n in $UI.get_children():
		if n.has_method("get_position"):
			og.set(n.get_name(), n.get_position())
	og.set(baddie.get_name(), baddie.get_position())
	
	$Timers/TextFreq.start(5)
	
	$Baddie/Sprite3D.play()
	$SFX/Car.play()

func _process(delta: float) -> void:
	
	is_player_hit()
	roadmove()
	do_crystals()
	do_trees()
	do_monster()
	UI_gubbins(delta)
	
	if Global.health < 1:
		die()
	
	pass


func _input(event: InputEvent) -> void:
	pass

func die():
	get_tree().change_scene_to_file("res://End.tscn")
	pass


# road movement subroutine
func roadmove():
	var road = $Road
	var asphalt_parent = $Road/Asphalt
	var asphalt_instances = asphalt_parent.get_children()
	var movespeed = 1
	
	road.position.x -= movespeed
	
	for n in asphalt_instances:
		if n.global_position.x <= -Global.road_l:
			n.queue_free()
			var asphalt = asphalt_scene.instantiate()
			asphalt.position.x = (n.position.x+400)
			asphalt_parent.add_child(asphalt)
			
func is_player_hit():
	
	if player.position.z >= Global.road_w/2 || player.position.z <= -Global.road_w/2:
		$UI/HitMask.color += Color(0,0,0,0.01)
		if $UI/HitMask.color.a > 0.9:
			$UI/HitMask.color = Color(1,0,0,0)
			die()
	else:
		$UI/HitMask.color -= Color(0,0,0,0.01)
		

func do_trees():
	var spawn_dist = 200
	var parent = $Road/Trees
	var living_trees = parent.get_children()
	var rel_pos = $Road.get_position()
	
	for n in living_trees:
		if n.global_position.x <= -Global.road_l:
			n.queue_free()
	
	if parent.get_children().size() < 20:
		var tree = object_scene.instantiate()
		tree.is_tree()
		tree.position.x = (-rel_pos.x) + randf_range(spawn_dist, spawn_dist+(Global.road_l*4))
		tree.position.y += 1
		if parent.get_children().size() % 2 == 0:
			tree.position.z = (-rel_pos.z) + randf_range((-Global.road_w/2), (-Global.road_w*2))
		else:
			tree.position.z = (-rel_pos.z) + randf_range((Global.road_w/2), (Global.road_w*2))
		parent.add_child(tree)
	pass

func do_crystals():
	var spawn_distance = 200
	var crystal_parent = $Road/Crystals
	var active_crystals = crystal_parent.get_children()
	var rel_pos = $Road.get_position()
	
	for n in active_crystals:
		if n.global_position.x <= -Global.road_l:
			n.queue_free()
			
	if crystal_parent.get_children().size() < 7:
		var crystal = object_scene.instantiate()
		crystal.is_crystal()
		crystal.position.x = (-rel_pos.x) + randf_range(spawn_distance, spawn_distance+(Global.road_l*4))
		crystal.position.z = (-rel_pos.z) + randf_range(-Global.road_w/2,Global.road_w/2)
		crystal_parent.add_child(crystal)
		
		
func do_monster():
	
	# movement #
	var player_pos = player.get_position()
	var baddie_pos = baddie.get_position()
	
	baddie.set_position(Vector3(
	move_toward(baddie_pos.x, player_pos.x, 0.012),
	og["Baddie"].y,
	move_toward(baddie_pos.z, player_pos.z, (0.1*ease(abs((player_pos.z-baddie_pos.z)/6), 0.5)))
	))
	############
	
	# getting hit #
	baddie_pos = baddie.get_position()
	
	if mon_knockback > 0:
		mon_knockback -= 1
		baddie.set_position(Vector3(
			move_toward(baddie_pos.x, player_pos.x+1, -0.05),
			og["Baddie"].y,
			baddie_pos.z
		))
	
	
	pass
	
	
func UI_gubbins(delta):
	
	####### Wheel Vibration #################
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(0), 0.1))
	if reset_wheel:
		wheel.set_position(og["Wheel"])
	if wheel.get_rotation() > 1 or wheel.get_rotation() < -1:
		if !$SFX/Tires.playing: $SFX/Tires.play()
		if Engine.get_frames_drawn() % 2 == 0:
			var newpos = wheel.get_position() + Vector2(randf_range(-15,15), randf_range(-15,15))
			wheel.set_position(newpos)
			reset_wheel = true
		else:
			reset_wheel = false
	else:
		$SFX/Tires.stop()
	
	var rhand = $UI/Wheel/Hand_R
	var lhand = $UI/Wheel/Hand_L
	rhand.set_rotation(move_toward(-wheel.get_rotation(), deg_to_rad(0), 0.2))
	lhand.set_rotation(move_toward(-wheel.get_rotation(), deg_to_rad(0), 0.2))
	#########################################
	
	######## Camera Tilt ###################
	
	cam.set_rotation(Vector3(0,0,(move_toward(cam.get_rotation().z, 0, (0.2*ease(abs(cam.get_rotation().z),1.5))))))
	rearview.set_rotation(Vector3(0, 90,(move_toward(rearview.get_rotation().z, 0, (0.2*ease(abs(rearview.get_rotation().z),1.5))))))
	rearview.set_position($Player.get_position())
	
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
	var object = area.get_parent()
	match object.type:
		"left":
			mon_knockback += 25
			object.queue_free()
			$UI.sfx("crystal_get.ogg")
		"right":
			mon_knockback += 25
			object.queue_free()
			$UI.sfx("crystal_get.ogg")
		"rainbow":
			Global.health += 1
			mon_knockback += 25
			object.queue_free()
			$UI.sfx("crystal_get.ogg")
		"baddie":
			mon_knockback += 30
			$UI.take_hit()
		_:
			object.queue_free()
			$UI.take_hit()
			pass
		
	pass # Replace with function body.


func _on_player_left() -> void:
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(-90), 0.2))
	cam.set_rotation(Vector3(0,0,(move_toward(cam.get_rotation().z, 0.5, 0.02))))
	rearview.set_rotation(Vector3(0,90,(move_toward(rearview.get_rotation().z, -0.5, 0.02))))
	tims.set_rotation(move_toward(tims.get_rotation(), -0.1, 0.3))
	coin_velocity += Vector2(-10, (randf_range(-0.005, 0.005)+randf_range(-0.005, 0.005)))
	pass


func _on_player_right() -> void:
	var wheel = $UI/Wheel
	wheel.set_rotation(move_toward(wheel.get_rotation(), deg_to_rad(90), 0.2))
	cam.set_rotation(Vector3(0,0,(move_toward(cam.get_rotation().z, -0.5, 0.02))))
	rearview.set_rotation(Vector3(0,90,(move_toward(rearview.get_rotation().z, 0.5, 0.02))))
	tims.set_rotation(move_toward(tims.get_rotation(), 0.1, 0.3))
	coin_velocity += Vector2(10, (randf_range(-0.005, 0.005)+randf_range(-0.005, 0.005)))
	pass


func _on_text_freq_timeout(timer: Timer) -> void:
	timer.start(5+(randf_range(-1,1)))
	$UI.do_text()
	$SFX/Notification.play()
	$Timers/ResponseTime.start(3)
	
	pass


func _on_ui_finger() -> void:
	mon_knockback += 1
	pass # Replace with function body.
