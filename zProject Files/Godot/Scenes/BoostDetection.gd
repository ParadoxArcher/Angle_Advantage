extends Area2D

var Bodies

func _ready():
	Bodies = [get_parent()]

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.append(body)
		print(Bodies)
		# add body to array
	
func _physics_process(_delta):
	pass
## in process
# create raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		print(body.position)
		
