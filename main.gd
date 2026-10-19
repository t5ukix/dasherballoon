extends Node2D

const LEVEL_TIME := 60.0
const PALETTE := [
	Color("fde2c4"),  # pastel saffron
	Color("d8f3dc"),  # pastel mint green
	Color("ffd6e0"),  # pastel rose
	Color("e0d7ff"),  # pastel indigo-lavender
	Color("ffe8a3"),  # pastel marigold
	Color("c5e8e4"),  # pastel peacock teal
]

@export var obstacle_scene: PackedScene
@export var arrow_scene: PackedScene

@onready var bg: ColorRect = $Background
@onready var finish_line: ColorRect = $FinishLine
@onready var balloon = $Balloon
@onready var message: Label = $UI/Message

var elapsed := 0.0
var playing := true
var palette_index := 0

func _ready():
	bg.color = PALETTE[0]
	$ObstacleTimer.timeout.connect(_spawn_obstacle)
	$ArrowTimer.timeout.connect(_spawn_arrow)
	$ColorTimer.timeout.connect(_change_background)
	balloon.hit.connect(_end_game.bind("Pop! Tap to try again"))

func _process(delta):
	if not playing:
		return
	elapsed += delta
	# obstacles get denser over time
	$ObstacleTimer.wait_time = max(0.4, 1.0 - elapsed * 0.01)
	# arrow phase begins 15 seconds before the end
	if elapsed >= LEVEL_TIME - 15.0 and $ArrowTimer.is_stopped():
		$ArrowTimer.start()
	# finish line slides down in the last 8 seconds
	if elapsed >= LEVEL_TIME - 8.0:
		finish_line.position.y += 100.0 * delta
		if finish_line.position.y >= balloon.position.y:
			_end_game("You made it! Tap to play again")

func _spawn_obstacle():
	var o = obstacle_scene.instantiate()
	o.position = Vector2(randf_range(40, 440), -50)
	add_child(o)

func _spawn_arrow():
	var a = arrow_scene.instantiate()
	var from_left := randf() < 0.5
	a.position = Vector2(-40 if from_left else 520, randf_range(100, 700))
	a.velocity = (balloon.position - a.position).normalized() * 380.0
	add_child(a)

func _change_background():
	palette_index = (palette_index + 1) % PALETTE.size()
	var tween := create_tween()
	tween.tween_property(bg, "color", PALETTE[palette_index], 1.5)  # smooth dissolve

func _end_game(text: String):
	if not playing:
		return
	playing = false
	message.text = text
	for t in [$ObstacleTimer, $ArrowTimer, $ColorTimer]:
		t.stop()
	balloon.set_process(false)

func _input(event):
	if not playing and event is InputEventMouseButton and event.pressed:
		get_tree().reload_current_scene()
