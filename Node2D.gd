extends Node2D

var paused = false
var circle = preload("res://circle.tscn")

onready var player = $Player
onready var ncp = $npc

func _ready():
	for i in range(500):
		var c = circle.instance()
		c.radius = randi() % 100
		c.stroke_width = randi() % 10
		c.position = Vector2(randi() % 1024, randi() % 768)
		add_child(c)
		c.random_color_timer()
		c.self_destruct((randf() * 4) + 1)

func toggle_physics():
	propagate_call("set_physics_process", [paused])
	paused = not paused
	
func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		toggle_physics()
