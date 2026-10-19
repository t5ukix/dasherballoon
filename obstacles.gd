extends Area2D

var kind := 0
var speed := 200.0
var spin := 1.0

func _ready():
	kind = randi() % 4
	speed = randf_range(180.0, 320.0)
	spin = randf_range(-2.0, 2.0)
	queue_redraw()

func _process(delta):
	position.y += speed * delta
	rotation += spin * delta
	if position.y > 950:
		queue_free()

func _draw():
	match kind:
		0: draw_circle(Vector2.ZERO, 28, Color("e9a23b"))   # marigold stone
		1: draw_rect(Rect2(-40, -9, 80, 18), Color("5a5ea8")) # indigo plank
		2: draw_colored_polygon(PackedVector2Array([Vector2(0, -30), Vector2(28, 24), Vector2(-28, 24)]), Color("e76f51")) # terracotta spike
		3: draw_colored_polygon(PackedVector2Array([Vector2(0, -32), Vector2(26, 0), Vector2(0, 32), Vector2(-26, 0)]), Color("2a9d8f")) # peacock diamond
