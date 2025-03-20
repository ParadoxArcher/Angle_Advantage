extends Area2D

@onready var ColliderInfo = {}

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):	
	
	#var bodyTransform = body.transform
	print(str(body.transform))
	var shapeRID = PhysicsServer2D.body_get_shape(body_rid, body_shape_index)
	var shapeType = PhysicsServer2D.shape_get_type(shapeRID)
	var localTransform = PhysicsServer2D.body_get_shape_transform(body_rid, body_shape_index)
	var shapeData = PhysicsServer2D.shape_get_data(shapeRID)
	ColliderInfo[shapeRID] = [shapeType, localTransform, shapeData]
	
	
func _physics_process(_delta):
	
	var ParentGlobalPos = get_parent().position
	var ParentRotation = get_parent().rotation
	
	print(str(ColliderInfo.size))
	
	#for shape in ColliderInfo:
	#	var RelativeGlobalPos = shape.position - ParentGlobalPos
	#	var LocalPos = Vector2(cos(ParentRotation) * RelativeGlobalPos.x, sin(ParentRotation) * RelativeGlobalPos.y)


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	ColliderInfo.erase(PhysicsServer2D.body_get_shape(body_rid, body_shape_index))
