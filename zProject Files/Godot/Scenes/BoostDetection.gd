extends Area2D

@onready var Bodies = [get_parent()]
@onready var raycast = $RayCast2D
var CollisionNormal


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.append(body)
	
func _physics_process(_delta):
	print(Bodies)
	for Body in Bodies:
		print(Body)
		if Body != Bodies[0]:
			raycast.target_position = Body.position
			print(Body)
			print(raycast.target_position)
			print(Body.position)
			if raycast.is_colliding():
				CollisionNormal = raycast.get_collision_normal()
				print(CollisionNormal)
	
#direct raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.erase(body)
	
