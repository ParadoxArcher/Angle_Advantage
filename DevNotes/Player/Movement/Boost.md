
### Final Work
###### Move forward in relation to rotation
#### Steps
1)  Define Input
	1) Project Settings --> Input Map --> "Boost" = W
	2) `var MoveInput = Input.get_action_strength("Boost)`
2) Movement
	1) Define Speed
		1) `@export var Speed = 1500`
	3) Inside `func _physics_process`
		1) Apply Speed to #velocity when Input is Pressed 
			2) `if MoveInput > 0:
				1) `velocity.y = Speed
		2) Activate #CharacterBody2D #velocity & physics
			1)  `move_and_slide()`
3) Acceleration
	1) Accelerate velocity
		1) Define #MaxSpeed and #SpeedAccel
			1) ~~Speed~~ -> `MaxSpeed`
			2) `@export var SpeedAccel = .15`
		2) Apply them to #velocity 
			1) `velocity = lerp(velocity, MaxSpeed, SpeedAccel)`
4) #BoostDirection based on #rotation
	1) Define variable outside physics process
		1) `var BoostDir = Vector2(0, 0)`
	2) Define #BoostDirection when trying to move and reset when not
		1) `if MoveInput > 0:
			1) `BoostDir = Vector2(cos(rotation), sin(rotation))
		2) `else:
			1) `BoostDir = Vector2(0, 0)
	3) Apply #MaxSpeed to #BoostDir and use the full #Vector2 of #velocity
		1) `velocity = lerp(velocity, BoostDir * MaxSpeed`
5) Counter Acceleration
	1) Find difference between current velocity and Boost direction & multiply it by deceleration rate before adding to acceleration
		1) ![[Pasted image 20250112074603.png]]
6) Boost Decay

### Adjustment log
- [[2025-01-14]]
	- Utilizes two separate #velocity adjustments to calculate momentum with #SpeedDecel and acceleration with #SpeedAccel 
- 