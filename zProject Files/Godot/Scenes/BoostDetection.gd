extends Area2D

@onready var Bodies = [get_parent()]
@onready var raycast = $RayCast2D


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.append(body)
	
func _physics_process(_delta):
	for Body in Bodies:
		raycast.target_position = Body.position
		if raycast.is_colliding():
			pass
		else:
			print_debug(str(get_parent()) + "/Raycast didn't collide!")
	
#direct raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.erase(body)
