### When keys are pressed, rotate at an accelerated rate

#### Steps
1) Define Input
	1) Project Settings --> Input Map --> "RotateLeft" = A || "RotateRight" = D
	2) `var MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost"))
2) Rotate
	1) Define Rotation Speed
		1) `@export var RotaSpeed = PI/24`
	2) Apply Rotation Speed
		1) `rotate(RotaSpeed)`
			1) must be before Physics application
				1) ![[Pasted image 20250111235849.png]]
3) Acceleration
	1) Accelerate rotation
		1) ![[Pasted image 20250112080726.png]]
	2) Create a rate of change and apply it
		1) ![[Pasted image 20250112081249.png]]
		2) ![[Pasted image 20250112081118.png]]
	3) Vary Acceleration based on acceleration or Deceleration
		1) ![[Pasted image 20250112081555.png]]
		2) ![[Pasted image 20250112081433.png]]
4) CounterSteer
	1) Find difference between current rotation Input direction & multiply it by deceleration rate before adding to acceleration
		1) ![[Pasted image 20250112081857.png]]