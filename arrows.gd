extends Area2D

var velocity := Vector2.ZERO

func _ready():
	rotation = velocity.angle()
	queue_redraw()

func _process(delta):
	position += velocity * delta
	if position.x < -100 or position.x > 580 or position.y < -100 or position.y > 950:
		queue_free()

func _draw():
	draw_line(Vector2(-30, 0), Vector2(20, 0), Color("5c4b51"), 4.0)
	draw_colored_polygon(PackedVector2Array([Vector2(34, 0), Vector2(18, -9), Vector2(18, 9)]), Color("5c4b51"))
