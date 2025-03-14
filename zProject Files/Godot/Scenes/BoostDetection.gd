extends Area2D

@onready var Bodies = [get_parent()]
@onready var raycast = $RayCast2D


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.append(body)
		print([Bodies])
	
func _physics_process(_delta):
	for Body in Bodies:
		pass
	
# per index
#direct raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.erase(body)
