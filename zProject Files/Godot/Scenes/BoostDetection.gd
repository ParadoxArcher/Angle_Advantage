extends Area2D

@onready var Bodies = [get_parent()]
@onready var raycast = $RayCast2D
var CollisionNormal


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.append(body)
		print(body.shape())
	
func _physics_process(_delta):
	
	var ParentGlobalPos = get_parent().position
	var ParentRotation = get_parent().rotation
	
	for Body in Bodies:
		if Body != Bodies[0]:
			var RelativeGlobalPos = Body.position - ParentGlobalPos
			var LocalPos = Vector2(cos(ParentRotation) * RelativeGlobalPos.x, sin(ParentRotation) * RelativeGlobalPos.y)
			print(LocalPos)
			raycast.target_position = LocalPos
			if raycast.is_colliding():
				CollisionNormal = raycast.get_collision_normal()
				print(CollisionNormal)
	
#direct raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.erase(body)
	
