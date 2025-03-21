extends Sprite2D

var x = 0
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	x += .02
	var circle = cos(x)
	
	print(transform)

	transform.x.x = 2 * circle
	transform.y.y = .5 * circle
