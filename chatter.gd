extends Node

var camera

var chats = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func say(text, audio, scene, speaker, interactor):
	var chatterbox = speaker.get_node("chatterbox")
	var chatterer = scene.instance()
	chatterbox.add_child(chatterer)
	chats.append(chatterer)
	chatterer.say(text, audio, speaker, interactor)
	return chatterer
