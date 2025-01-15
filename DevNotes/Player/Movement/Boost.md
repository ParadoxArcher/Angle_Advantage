
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
		1) Apply Speed to velocity when Input is Pressed 
			2) `if MoveInput > 0:
				1) `velocity.y = Speed
		2) Activate CharacterBody2D velocity & physics
			1)  `move_and_slide()`
3) Acceleration
	1) Accelerate velocity
		1) `Speed` -> `MaxSpeed`
		2) `velocity = lerp(velocity, MaxSpeed`
	3) Create a rate of change and apply it
		1) ![[Pasted image 20250112001504.png]]
		2) ![[Pasted image 20250112002903.png]]
	4) Vary Acceleration based on acceleration or Deceleration
		1) ![[Pasted image 20250112002430.png]]
		2) ![[Pasted image 20250112002646.png]]
4) Boost direction based on Rotation
	1) Create variable outside physics process
		1) ![[Pasted image 20250112003332.png]]
	2) Define Boost Direction when trying to moving and reset when not
		1) ![[Pasted image 20250112003124.png]]
	3) Apply MaxSpeed to BoostDir and use the full Vector2 of velocity
		1) ![[Pasted image 20250112003537.png]]
5) Counter Acceleration
	1) Find difference between current velocity and Boost direction & multiply it by deceleration rate before adding to acceleration
		1) ![[Pasted image 20250112074603.png]]
6) Boost Decay

### Adjustment log
- [[2025-01-14]]
	- Utilizes two separate #velocity adjustments to calculate momentum with #SpeedDecel and acceleration with #SpeedAccel 
- 