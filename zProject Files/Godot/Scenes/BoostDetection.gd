extends Area2D

@onready var ColliderInfo = {}
@onready var raycast = $RayCast2D
var CollisionNormal




func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):	
	
	var shape_rid = PhysicsServer2D.body_get_shape(body_rid, body_shape_index)
	#var local_pos = PhysicsServer2D.body_get_shape_transform(body_rid, body_shape_index).origin
	print(str(PhysicsServer2D.body_get_shape_transform(body_rid, body_shape_index).origin))
	#ColliderInfo[str(shape_rid)] = []
	#print("body: " + str(body) + " || body_rid: " + str(body_rid) + " || body_shape_index: " + str(body_shape_index))
	#print("shape_RID: " + str(shapeRID))
	#print("shape_transform: " + str(PhysicsServer2D.body_get_shape_transform(body_rid, body_shape_index)) + " || shape_type: " + str(PhysicsServer2D.shape_get_type(shapeRID)) + " || shape_data: " + str(PhysicsServer2D.shape_get_data(shapeRID)))
	
func _physics_process(_delta):
	
	var ParentGlobalPos = get_parent().position
	var ParentRotation = get_parent().rotation
	
	for Body in ColliderInfo:
		var RelativeGlobalPos = Body.position - ParentGlobalPos
		var LocalPos = Vector2(cos(ParentRotation) * RelativeGlobalPos.x, sin(ParentRotation) * RelativeGlobalPos.y)

	
#direct raycast towards body shape
# get collision normal
# return collision normal to PlayerScript via signal

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	ColliderInfo.erase(body_rid)
	
