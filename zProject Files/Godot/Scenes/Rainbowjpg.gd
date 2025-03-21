extends Sprite2D

func _ready():
	print(transform)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
var x = 0

func _process(delta):
	x += .02
	var cycle = cos(x)
	
	#transform.y = Vector2(-sin(.75), cos(.75))
	#transform.x = Vector2(cos(.75), sin(.75))

	print(transform)
