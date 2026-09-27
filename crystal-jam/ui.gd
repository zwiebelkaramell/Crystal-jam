extends CanvasLayer

var start_time
var order
var answered
var hitsounds = []
var no_repeat

signal finger()
	
@onready var og_wheel_pos = $Wheel.get_position()
@onready var phone_label = $TextController/Container/HisMsg
@onready var b1 = $TextController/Button1/Label
@onready var b2 = $TextController/Button2/Label
@onready var timer_bar = $TextController/Timer_UI
@onready var health = $"Health Label"

var texts = [
# question, good response, bad response
	["hey bby where you at?", "running late sry", "running from ur ass"],
	["i'm waitin on you gorl!", "sorry stud ;)", "sorry loser >:P"],
	["what color is ur car again?", "it's pink af", "black, like my soul..."],
	["is this the wrong mcdonalds?", "no, be right there", "ur a mcdumbass XD"],
	["you gonna run, honeybun?", "running to meet you boo <3", "bet ur \"buns\", bozo"],
	["how much longer u gonna be?", "like 5 mins, lol", "like 5 years, lmao"],
	["ordering, what drink u want?", "your favorite!", "red 40"],
	["i hope youre worth the wait", "i am, trust", "scrollin tinder rn"],
	["we should get mexican next time", "i'm up for anything", "we're kidnapping someone????"],
	["jason- hot man 5 miles away", "not interested", "swipe right"],
	["lisa- hot milfs in your neigbborhood", "maybe next time", "call lisa"],
]

func _ready() -> void:
	for i in range(1,7):
		var path = "res://Assets/Audio/hit_" + str(i) + ".ogg"
		hitsounds.append(load(path))
	pass

func _process(delta: float) -> void:
	if timer_bar.visible:
		var time = Time.get_unix_time_from_system()
		var time_diff = abs(start_time - time)
		timer_bar.value = 100-(time_diff*33.334)
		
	health.text = "X " + str(Global.health) 
	$Finger.position = get_viewport().get_mouse_position()
	if $Finger.visible && (Engine.get_frames_drawn()%3) == 0 :
		finger.emit()
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		$Wheel/Hand_R.visible = false
		$Finger.visible = true
	elif event.is_action_released("action"):
		$Wheel/Hand_R.visible = true
		$Finger.visible = false
		pass

func take_hit():
	$HitMask.set_color(Color(1,0,0,0.4))
	var roll = randi_range(0,(hitsounds.size()-1))
	if roll == no_repeat:
		roll = randi_range(0, hitsounds.size()-2)
		if roll >= no_repeat:
			roll += 1
	no_repeat = roll
	$Audio.set_stream(hitsounds[roll])
	$Audio.play()
	Global.health -= 1

func do_text():
	order = randi_range(0,1)
	var selection = (randi_range(0,(texts.size()-1)))
	phone_label.text = texts[selection][0]
	
	b1.text = texts[selection][order+1]
	b2.text = texts[selection][((1+order)%2)+1]
	pass
	
func fail():
	var m = [">:(", ";c", ",':[", ":/", "OnO", "[-_-*]"]
	phone_label.text = m[randi_range(0, (m.size()-1))]
	b1.text = ""
	b2.text = ""
	take_hit()
	timer_bar.visible = false
	pass
func no_fail():
	var t = [":)",";P",":3","<:o)","^_^", ":D"]
	phone_label.text = t[randi_range(0, (t.size()-1))]
	b1.text = ""
	b2.text = ""
	timer_bar.visible = false
	pass

func _on_text_freq_timeout() -> void:
	timer_bar.visible = true
	timer_bar.value = 100
	start_time = Time.get_unix_time_from_system()
	answered = false
	pass


func _on_response_time_timeout() -> void:
	timer_bar.visible = false
	if !answered:
		fail()
	pass


func _on_button_1_pressed() -> void:
	answered = true
	if order == 0:
		no_fail()
	else:
		fail()
	pass
func _on_button_2_pressed() -> void:
	answered = true
	if order == 1:
		no_fail()
	else:
		fail()
	pass
