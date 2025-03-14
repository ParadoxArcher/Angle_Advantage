extends Area2D


## detect collision (on body shape entered)
# get body shape
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var bodyRID = body_rid
	print(body)
	pass # Replace with function body.
	
func _physics_process(_delta):
	pass
## in process
# create raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

## end collision (body shape exited)
