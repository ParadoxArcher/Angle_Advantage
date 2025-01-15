
### Final Work
###### Move forward in relation to rotation
#### Steps
1)  Define Input
	1) Project Settings --> Input Map --> "Boost" = W
	2) `var MoveInput = Input.get_action_strength("Boost)`
2) Movement
	1) Define Speed
		1) `@export var Speed = 1500`
	3) Inside `func _physics_process(_delta):`
		1) Apply Speed to #velocity when Input is Pressed 
			2) `if MoveInput > 0:
				1) `velocity.y = Speed
		2) Activate #CharacterBody2D #velocity & physics
			1)  `move_and_slide()`
3) Acceleration
	1) Accelerate #velocity
		1) before `func _physics_process(_delta):` Define #MaxSpeed and #SpeedAccel `
			1) ~~Speed~~ -> `MaxSpeed`
			2) `@export var SpeedAccel = .01`
		2) Apply them to #velocity math
			1) `velocity.y = lerp(velocity, MaxSpeed, SpeedAccel)`
4) #BoostDir based on #rotation
	1) Define #BoostDir  before `func _physics_process(_delta):`
		1) `var BoostDir = Vector2(0, 0)`
	2) Inside `func _physics_process:` and before `move_and_slide()`
		1) Define #BoostDir when trying to move and reset when not
			1) `if MoveInput > 0:
				1) `BoostDir = Vector2(cos(rotation), sin(rotation)) * MoveInput.y
			2) `else:
				1) `BoostDir = Vector2(0, 0)
		2) Apply #MaxSpeed to #BoostDir and use the full #Vector2 of #velocity
			1) `velocity = lerp(velocity, BoostDir * MaxSpeed, SpeedAccel)`
5) Preserve Momentum
	1) Define #SpeedDecel 
		1) `@export var SpeedDecel = .005`
	2) Inside `func _physics_process(_delta):` and before `move_and_slide()`
		1) create another #velocity adjustment and lerp it to it's `normalized()` value by #SpeedDecel
			1) `velocity = lerp(velocity, velocity.normalized(), SpeedDecel)`
6) #BoostDecay
	1) Define a #BoostDecay array with 3 variables; a settable, an application ratio, and an initial value
		1) `@export var BoostDecay = [0, .015, .8]`
	2) Set up BoostDecay to activate
		1) Inside #BoostDir if statement increase #BoostDecay [0] by #BoostDecay[1] and apply clampf to prevent exceeding #MoveInputY
			1) `BoostDecay[0] += clampf(BoostDecay[1], 0, MoveInput.y)`
		2) Allow #BoostDecay to pass through #BoostDir if statement
			1) `if MoveInput.y > 0 or BoostDecay[0] > 0:`
	3) Adjust value of #BoostDir by #BoostDecay when not moving
		1) Take original portion and set if statement to only activate when #MoveInputY is greater than #BoostDecay[0]. Divide #MoveInputY by #BoostDecay[2] to prevent controllers from toggling between base #BoostDir and the weaker #BoostDecay #BoostDir
			1) `if MoveInput.y > 0 or BoostDecay[0] > 0:
				1) `if MoveInput.y / BoostDecay [2] >= BoostDecay[0]:
		2) In the else portion, set a weaker #BoostDir proportional to #BoostDecay[1] & [2] before subtracting from #BoostDecay[0] by #BoostDecay [1]
			1) `else:
				1) `Vector2(cos(rotation), sin(rotation)) * BoostDecay[0] * BoostDecay[2]
				2) `BoostDecay[0] -= clampf(BoostDecay[1], 0, BoostDecay[0])`
		3) Separate #BoostDir adjustments into new variable for if statement, then combine with main portion of #BoostDir math at end
			1) `if MoveInput.y > 0 or BoostDecay[0] > 0:
				1) `var BoostDirAmp
				2) `if MoveInput.y / BoostDecay[2] >= BoostDecay[0]:
					1) `BoostDirAmp = MoveInput.y
					2) `BoostDecay[0] += clampf(BoostDecay[1], 0, MoveInput.y)
				3) `else:
					1) `BoostDirAmp = BoostDecay[0] * BoostDecay[2]
					2) `BoostDecay[0] -= clampf(BoostDecay[1], 0, BoostDecay[0])
				4) `BoostDir = Vector2(cos(rotation), sin(rotation)) * BoostDirAmp
### Adjustment log
- [[2025-01-13]]
	- Added #BoostDecay
- [[2025-01-14]]
	- Utilizes two separate #velocity adjustments to calculate momentum with #SpeedDecel and acceleration with #SpeedAccel 
	- When [[Boost|BoostDecay]] isn't active, #BoostDir is amplified by #MoveInputY value 