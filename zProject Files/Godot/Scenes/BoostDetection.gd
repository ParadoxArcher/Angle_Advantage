extends Area2D

func _physics_process(_delta):
	print(Collision.get_normal())



func _on_body_entered(body):
	pass # Replace with function body.
