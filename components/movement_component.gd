class_name MovementComponent
extends Node

@export var actor : Node2D
@export var velocity : Vector2

func process(delta):
	actor.translate(velocity * delta)
