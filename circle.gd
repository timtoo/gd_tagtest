extends Sprite

export var radius: float = 10
export var stroke_width: float = 0
export var color: Color = Color.black
export var stroke_color: Color = Color.yellow

func random_color_timer(max_time=3):
	random_colors()
	var t = Timer.new()
	t.wait_time = randf() * max_time
	t.one_shot = false
	t.connect("timeout", self, "random_colors")
	t.set_autostart(true)
	add_child(t)
	return self
	
func setup(radius=radius, color=color, stroke_width=stroke_width, stroke_color=stroke_color):
	self.radius = radius
	self.color = color
	self.stroke_width = stroke_width
	self.stroke_color = stroke_color
	return self
	
func self_destruct(seconds:float):
	# do not call before circle has been added to tree (add_child)
	var timer: Timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "_self_destruct")
	add_child(timer)
	timer.start(seconds)
	return self
	
func random_colors():
	color = Color(randf(), randf(), randf())
	stroke_color = Color(randf(), randf(), randf())
	update()
	return self
	
func _self_destruct():
	queue_free()

func _draw():
	if stroke_width:
		draw_circle(Vector2.ZERO, radius, stroke_color)
	draw_circle(Vector2.ZERO, radius - stroke_width, color)
		

