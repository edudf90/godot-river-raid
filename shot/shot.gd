extends Node2D

const SHOT_SPEED = 300.
const OFFSET = Vector2(0., -40.)

signal hit_a_mob

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("body_entered", handle_body_collision)
	$Area2D.connect("area_entered", handle_area_collision)
	$Area2D.add_to_group("bullet")
	hit_a_mob.connect(get_parent().on_mob_hit)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position.y < 0:
		stop()
	$MovementComponent.process(delta)
	pass

func get_fired(firing_position):
	position = firing_position + OFFSET
	$MovementComponent.velocity = Vector2(0., -SHOT_SPEED)

func stop():
	position = Vector2(-100., -100.)
	$MovementComponent.velocity = Vector2(0., 0.)

func handle_area_collision(collider : Area2D):
	if collider != null && collider.get_parent() != null && \
	collider.get_parent() is Mob:
		stop()
		hit_a_mob.emit()

func handle_body_collision(collider : Node2D):
	if collider != null && collider is Land:
		stop()
