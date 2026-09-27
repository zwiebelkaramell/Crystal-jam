extends CanvasLayer

var start_time
var order
var answered
var hitsounds = []
var no_repeat
	
@onready var og_wheel_pos = $Wheel.get_position()
@onready var phone_label = $TextController/HisMsg
@onready var b1 = $TextController/Button1
@onready var b2 = $TextController/Button2
@onready var timer_bar = $TextController/Timer_UI

var texts = [
# question, good response, bad response
	["hey bby where you at?", "running late sry", "running from ur ass"],
	["i'm waitin on you gorl!", "sorry stud ;)", "sorry loser >:P"],
	["what color is ur car again?", "it's pink af", "black, like my soul..."],
	["is this the wrong mcdonalds?", "no, be right there", "ur a mcdumbass XD"],
	["you gonna run, honeybun?", "running to meet you boo <3", "bet ur \"buns\", bozo"],
	["how much longer u gonna be?", "like 5 mins, lol", "like 5 years, lmao"],
]

func _ready() -> void:
	for i in range(1,7):
		var path = "res://Assets/Audio/hit_" + str(i) + ".ogg"
		hitsounds.append(load(path))
	pass

func _process(delta: float) -> void:
	$Label.text = str(Global.health)
	if timer_bar.visible:
		var time = Time.get_unix_time_from_system()
		var time_diff = abs(start_time - time)
		timer_bar.value = 100-(time_diff*33.334)
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
	phone_label.text = ">:("
	b1.text = ""
	b2.text = ""
	take_hit()
	timer_bar.visible = false
	pass
func no_fail():
	var t = [":)",";P",":3","<:o)","^_^"]
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
