extends Area2D

@onready var Bodies = [get_parent()]
@onready var raycast = $RayCast2D
var CollisionNormal




func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(str(body_rid))
	print(str(PhysicsServer2D.body_get_shape(body_rid, 0)))
	if body != Bodies[0]:
		Bodies.append(body)
	
func _physics_process(_delta):
	
	var ParentGlobalPos = get_parent().position
	var ParentRotation = get_parent().rotation
	
	for Body in Bodies:
		if Body != Bodies[0]:
			var RelativeGlobalPos = Body.position - ParentGlobalPos
			var LocalPos = Vector2(cos(ParentRotation) * RelativeGlobalPos.x, sin(ParentRotation) * RelativeGlobalPos.y)
			raycast.target_position = LocalPos
			if raycast.is_colliding():
				CollisionNormal = raycast.get_collision_normal()
	
#direct raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body != Bodies[0]:
		Bodies.erase(body)
	
