extends KinematicBody2D

var dot = preload("res://circle.tscn")

onready var screensize = get_viewport_rect().size
onready var marker = get_parent().get_node("Marker")
onready var player = get_parent().get_node("Player")

var direction = Vector2.ONE
var speed = 200

# varaibles for look_around
const RADS = 2 * PI
const max_opponent_distance = 80
const lookray_count = 7
var lookray_distance = 150
var lookray_delay = 0.75
var lookray = []

func _ready():
	randomize()
	position = Vector2(screensize.x / 2, screensize.y / 2)
	direction = direction.rotated(deg2rad(randi() % 360))
	direction = position.direction_to(player.position) * -1
	
	print ("player start position", player.position)
	
	# create timer to trigger look_around
	var timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = lookray_delay
	timer.connect("timeout", self, "look_around")
	add_child(timer)
	timer.start()

	# create raycast objects to be used for look_around	
	for i in range(lookray_count):
		var rc = RayCast2D.new()
		add_child(rc)
		lookray.append(rc)

func _physics_process(delta):
	move_and_slide(direction * speed)
	$RayCast2D.cast_to = direction * screensize.y
	
	if $RayCast2D.is_colliding():
		marker.global_position = $RayCast2D.get_collision_point()
	
	if get_slide_count():
		direction = direction.bounce(get_slide_collision(0).normal)
		#look_around() # gets stuck in corner more
	
	var direction_from_player = position.direction_to(player.position) * -1
	$LineFP.points[1] = direction_from_player * 60
	var angle_d = rad2deg(direction.angle())
	var angle_fp = rad2deg(direction_from_player.angle())
	#print (direction, angle_d, direction_from_player, angle_fp)
	#print (angle_d - angle_fp)
	
	$Line2.points[1] = (direction + direction_from_player) * 60
	#direction = (direction + direction_from_player) / 2

func look_around():
	var farthestd = null
	var farthest = 0.0
	var c = Color(randf(), randf(), randf())
	
	for rc in lookray:
		var loc = Vector2.ONE.rotated(randf() * RADS) * lookray_distance
		rc.cast_to = loc
		rc.force_raycast_update()
		if rc.is_colliding():
			loc = rc.get_collision_point()
		else:
			# convert local to global position
			loc = position + loc
				
		# draw dot for visualization
		var d = dot.instance()
		d.radius = 5
		d.color = c
		d.stroke_width = 1
		get_parent().add_child(d)
		d.global_position = loc
		d.self_destruct(1.8)
	
		# player position closer to player to get out of corners sooner
		var fake_player_pos = position + position.direction_to(player.position) * max_opponent_distance
		
		# check if further location to player
		var d2 = dot.instance()
		d2.color = Color.red
		d2.position = fake_player_pos
		get_parent().add_child(d2)
		d2.self_destruct(3)
		
		var dist = min(loc.distance_to(fake_player_pos), loc.distance_to(player.position))
		if dist > farthest:
			farthest = dist
			farthestd = d
			
	# update appearance of biggest dot
	farthestd.radius = 10
	farthestd.color = Color.black
	farthestd.update()		
	
	direction = position.direction_to(farthestd.position)
		
		
	
	
	
	

