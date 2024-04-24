class_name BorderCollisionHandler
extends Node

@export var area : Area2D
@export var movement_component : MovementComponent

func _ready():
	area.body_entered.connect(handle_collision)

func handle_collision(body):
	if body is Land:
		var new_velocity = Vector2(-movement_component.velocity.x, movement_component.velocity.y)
		movement_component.velocity = new_velocity
