class_name Enemy
extends Mob

var rng : RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_rng(generator):
	rng = generator
