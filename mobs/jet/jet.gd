class_name Jet
extends Enemy

const JET_SPEED = 120.
const RESPAWN_OFFSET = 30.

var velocity : Vector2 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.add_to_group("obstacle")
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if velocity.x < 0 && position.x < 0.:
		position.x = DisplayServer.window_get_size().x + RESPAWN_OFFSET
	elif velocity.x > 0 && position.x > DisplayServer.window_get_size().x:
		position.x = 0. - RESPAWN_OFFSET
	$MovementComponent.process(delta)

func set_direction(direction : float):
	var x_velocity = JET_SPEED if direction > 0 else - JET_SPEED
	velocity = Vector2(x_velocity, 0.)
	$MovementComponent.velocity = velocity

func reset():
	set_direction(rng.randf_range(-1., 1.))
