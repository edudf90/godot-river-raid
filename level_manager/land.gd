class_name Land
extends StaticBody2D

var polygon : Polygon2D
var collision_shape : CollisionPolygon2D

func add_nodes_to_tree():
	add_child(polygon)
	add_child(collision_shape)
