### When keys are pressed, rotate at an accelerated rate

#### Steps
1) Define Input
	1) Project Settings --> Input Map --> "RotateLeft" = A || "RotateRight" = D
	2) `var MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost"))
2) Rotate
	1) Define Rotation Speed
		1) `@export var RotaSpeed = PI/24`
	2) Inside `func _physics_process:` and before `move_and_slide()`
		1) Apply Rotation Speed
			1) `rotate(RotaSpeed)`
3) Acceleration[[ToDoList]]
	1) Declare #RotaSpeed
	2) Accelerate rotation
		1) `RotaSpeed = lerp(RotaSpeed, MoveInput.x * MaxRota`
	3) Create a rate of change and apply it
		1) 
		2) 
	4) Vary Acceleration based on acceleration or Deceleration
		1) 
		2) 
5) CounterSteer
	1) Find difference between current rotation Input direction & multiply it by deceleration rate before adding to acceleration