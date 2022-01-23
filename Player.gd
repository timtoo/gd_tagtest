extends KinematicBody2D

onready var npc = get_parent().get_node("npc")

var speed = 100
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(randi() % int(get_viewport_rect().size.x),
					   randi() % int(get_viewport_rect().size.y))
					
	print ("player position start", position)
					
func _physics_process(delta):
	move_and_slide(position.direction_to(npc.position) * speed)
	
	if get_slide_count():
		$Sprite.modulate = Color.red
	else:
		$Sprite.modulate = Color.darkgreen
