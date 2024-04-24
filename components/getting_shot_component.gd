class_name GettingShotComponent
extends Node

@export var area : Area2D
@export var actor : Node2D
@export var movement_component : MovementComponent

var explosion_resource = preload("res://explosion/explosion.tscn")
var explosion

func _ready():
	area.area_entered.connect(handle_collision)
	explosion = explosion_resource.instantiate()
	actor.call_deferred("add_child", explosion)

func handle_collision(collider):
	if collider.is_in_group("bullet"):
		movement_component.velocity = Vector2(0.,0.)
		explosion.position = Vector2(2 * actor.position.x, 0.)
		actor.position = Vector2(-actor.position.x, actor.position.y)
		explosion.emitting = true
