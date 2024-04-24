class_name FuelStation
extends Mob

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.add_to_group("fuel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
