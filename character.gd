extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var SPEED = 90
var busy = false
onready var chatter = get_node("/root/Chatter")
onready var camera = get_node("Camera2D")
export var is_main_player = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dx = 0
	var dy = 0
	if Input.is_action_pressed("ui_up"):
		dy -= SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		dy += SPEED*delta
	if Input.is_action_pressed("ui_right"):
		dx += SPEED * delta
	elif Input.is_action_pressed("ui_left"):
		dx -= SPEED*delta
	var mv = Vector2(dx,dy)
	if !busy:
		move_and_collide(mv)
	
