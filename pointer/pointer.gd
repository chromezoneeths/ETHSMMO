extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var anim = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("scale_in")
	pass # Replace with function body.

func destroy():
	anim.play_backwards("scale_in")
	yield(anim, "animation_finished")
	queue_free()

func hide():
	anim.play_backwards("scale_in")

func show():
	anim.play("scale_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
