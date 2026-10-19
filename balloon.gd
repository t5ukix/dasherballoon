extends Area2D
signal hit

var target := Vector2(240, 650)

func _ready():
	area_entered.connect(func(_other): hit.emit())

func _input(event):
	if (event is InputEventMouseButton and event.pressed) \
	or (event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		target = get_global_mouse_position()

func _process(delta):
	position = position.lerp(target, 5.0 * delta)          # floaty, drifting feel
	position.y += sin(Time.get_ticks_msec() / 400.0) * 0.4  # gentle bobbing
	position.x = clamp(position.x, 40, 440)
	position.y = clamp(position.y, 40, 780)

func _draw():
	draw_line(Vector2(0, 42), Vector2(0, 110), Color("b8b5c9"), 2.0)
	draw_colored_polygon(PackedVector2Array([Vector2(0, 36), Vector2(-7, 49), Vector2(7, 49)]), Color("cfcbe3"))
	draw_circle(Vector2.ZERO, 42, Color("cfcbe3"))            # shaded edge
	draw_circle(Vector2(-4, -5), 36, Color("e9e6f4"))         # mid tone
	draw_circle(Vector2(-9, -11), 27, Color.WHITE)            # bright face
