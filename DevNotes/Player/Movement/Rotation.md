### When keys are pressed, rotate at an accelerated rate

#### Steps
1) Define Input
	1) Project Settings --> Input Map --> "RotateLeft" = A || "RotateRight" = D
	2) Reformat #MoveInput
		1) `var MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost"))
2) Rotate
	1) Define #RotaSpeed
		1) `@export var RotaSpeed = PI/24`
	2) Inside `func _physics_process:` and before `move_and_slide()`
		1) Apply Rotation Speed
			1) `rotate(RotaSpeed)`
3) Acceleration
	1) Before `func _physics_process:` Declare  #MaxRota, #RotaAccel, and #RotaSpeed
		1) `@export var MaxRota = PI/24`
		2) `@export var RotaAccel = .02`
		3) `var RotaSpeed = 0
	2) Accelerate rotation
		1) `RotaSpeed = lerp(RotaSpeed, MoveInput.x * MaxRota, RotaAccel) 
		2) `rotate(RotaSpeed)`
4) Separate acceleration and deceleration speeds
	1) Before `func _physics_process:` Declare #RotaRate
		1) `var RotaRate = 0`
	2) Inside `func _physics_process:` and before `RotaSpeed` math
		1) `if MoveInput.x != 0:
			1) `RotaRate = RotaAccel[0]
		2) `else:
			1) `RotaRate = RotaDecel[0]
5) #CounterSteer
	1) Before `func _physics_process:` define #CounterSteerRate
		1) `@export var CounterSteerRate = .35`
	2) Inside `if MoveInput.x != 0:`
		1) Take #RotaSpeed / #MaxRota then subtract #MoveInputX, afterwards take that value's absf in order to get a result varying between 0 -> 2 for how strong the countersteer is. [[Drawing 2025-01-10 12.04.56.excalidraw]]. Mulitply by #CounterSteerRate
			1) `var CounterSteer = absf((RotaSpeed / MaxRota ) - MoveInput.x) * CounterSteerRate
		2) Multiply #CounterSteer to #RotaDecel when added to #RotaAccel
			1) `RotaRate = RotaAccel[0] + RotaDecel[0] * CounterSteer`