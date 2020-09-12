extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal done

export var scale_in_time = .2

var state = State.Sleeping
var timer = 0
var timerUntil = 0
var textToSay = []
var Interactor

onready var label = get_node("ReferenceRect/MarginContainer/Label")
onready var anim = get_node("AnimationPlayer")

enum State {
	Sleeping,
	ScaleIn,
	Writing,
	Waiting,
	ScaleOut,
	Freeing
}

func _ready():
	rect_scale = Vector2(0,0)

func _process(delta):
	if state == State.Sleeping:
		pass
	elif state == State.ScaleIn:
		timer += delta
		if timer > timerUntil:
			to_writing()
	elif state == State.Writing:
		var ch = textToSay.pop_back()
		if ch == "\n" or ch == null:
			to_waiting()
		else:
			label.text = label.text + ch
		pass
	elif state == State.Waiting:
		if Input.is_action_just_pressed("interact"):
			if len(textToSay) == 0:
				state = State.ScaleOut
				if Interactor:
					if Interactor.has_method("set_busy"):
						Interactor.set_busy(false)
				anim.play_backwards("scale_in")
			else:
				to_writing()
	elif state == State.ScaleOut:
		if(!anim.is_playing()):
			state = State.Freeing
	elif state == State.Freeing:
		emit_signal("done")
		get_parent().remove_child(self)
		queue_free()

func say(text, audio, speaker, interactor):
	Interactor = interactor
	if interactor:
		if interactor.has_method("set_busy"):
			interactor.set_busy(true)
	anim.play("scale_in")
	textToSay = []
	for i in range(text.length()):
		textToSay.append(text.substr(text.length()-(i+1),1))
	state = State.ScaleIn
	timer = 0
	timerUntil = scale_in_time
	pass

func to_writing():
	timer = 0
	timerUntil = rand_range(.1,.2)
	label.text = ""
	state = State.Writing

func to_waiting():
	state = State.Waiting
