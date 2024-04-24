class_name Boat
extends Enemy

const HORIZONTAL_MIDDLE = 480.0
const BOAT_SPEED = 80.

var speed_modifier = 1.

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.add_to_group("obstacle")
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$MovementComponent.process(delta)

func reset():
	if position.x > HORIZONTAL_MIDDLE:
		speed_modifier = -1.
	$MovementComponent.velocity = Vector2(speed_modifier * BOAT_SPEED, 0.)

