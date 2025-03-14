extends Area2D

#Make array

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body != get_parent():
		print(body.position)
		# add body to array
	
func _physics_process(_delta):
	pass
## in process
# create raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal




func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
