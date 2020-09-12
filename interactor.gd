extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var interacted_object;
var busy = false;
var pointer = load("res://pointer/pointer.tscn")

onready var interactionCollider

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var collision = move_and_collide(Vector2.ZERO, true, true, true)
	var new_interacted_object
	if collision:
		new_interacted_object = collision.collider
	else:
		new_interacted_object = null
	if new_interacted_object != interacted_object and !busy:
		if new_interacted_object:
			if new_interacted_object.get_node("pointer_spot") and new_interacted_object.has_method("_interact"):
				new_interacted_object.get_node("pointer_spot").add_child(pointer.instance())
		if interacted_object:
			if interacted_object.get_node("pointer_spot"):
				var spot = interacted_object.get_node("pointer_spot")
				var children = interacted_object.get_node("pointer_spot").get_children()
				for i in children:
					if i.has_method("destroy"):
						i.destroy()
					else:
						spot.remove_child(i)
						i.queue_free()
	interacted_object = new_interacted_object
	if Input.is_action_just_pressed("interact") and !busy:
		if interacted_object:
			if interacted_object.has_method("_interact"):
				if interacted_object.get_node("pointer_spot/pointer"):
					interacted_object.get_node("pointer_spot/pointer").hide()
				interacted_object._interact(self)
				if interacted_object.has_signal("done_interacting"):
					yield(interacted_object, "done_interacting")
				if interacted_object.get_node("pointer_spot/pointer"):
					interacted_object.get_node("pointer_spot/pointer").show()
			else:
				default_interact()

func default_interact():
	pass

func set_busy(b):
	busy = b
	get_parent().busy = b
