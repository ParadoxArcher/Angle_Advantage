### Final Work

#### Needs
1) Accelerate forward, relative to current rotation
2) Decelerate due to friction
3) Create amplify friction when using brakes
#### Steps
1)  Define Input
	1) Project Settings --> Input Map --> "Boost" = W
	2) Create `func _moveInput():`
		1) have `_moveInput()` `return` the dedicated inputs
			1) `return Input.get_axis("Boost", 0)`
	3) Inside `func _physics_process(_delta):`
		1) `var MoveInput = _moveInput()`
2) Movement
	1) Define #Speed  as `global variable`
		1) `@export var Speed = 1500`
	2) Create `func _boost(YInput):`
		1) invert `YInput` so `-1` `=` `1`
		2) Apply #Speed to #velocity when Input is Pressed 
			2) `if YInput > 0:
				1) `velocity.y = Speed
	3) Inside `func _physics_process(_delta):`
		1) Call `_boost()` and insert #MoveInput 
			1) `_boost(MoveInput)`
		2) Activate #CharacterBody2D #velocity & physics
			1)  `move_and_slide()`
3) Acceleration
	1) Accelerate #velocity
		1) Define #MaxSpeed as `global variables` and #SpeedAccel as a `Global Array`
			1) ~~`Speed`~~ -> `MaxSpeed`
			2) `@export var SpeedAccel = {.01, .01}`
		2) Adjust #SpeedAccel based on Input
			1)  Define #SpeedAccel1 as #SpeedAccel0 within `func _boost():` 
				1) `if YInput > 0:` 
					1) ~~`velocity.y = Speed`~~
					2) `SpeedAccel[0] = SpeedAccel[1]`
			2) Set #SpeedAccel1 to `0` in `else:`
				1) `else:`
					1) `SpeedAccel[1] = 0`
			3) Move #velocity adjustment under `if -MoveInput > 0:` function and apply #MaxSpeed and #SpeedAccel1 to it
				1) `velocity.y = lerp(velocity, MaxSpeed, SpeedAccel[1])`
		3) Implement #BoostDir 
			2) Use the full #Vector2 of #velocity and multiply #MaxSpeed by `cos` and `sin` of #rotation 
				1) `velocity = lerp(velocity, Vector2.from_angle(rotation) * MaxSpeed, SpeedAccel[1])`
4) #Friction & Momentum
	1) Define #Friction  as `global array`, for a fluctuating variable, and a base
		1) `@export var Friction = [.002, .002]`
	2) Define #FrictRate as `global array`, for the actuation multiplier, step size, and step strength
		1) `@export var FrictRate = [.2, .04, .08]`
	3) Inside `func _friction()`
		1) Reset #Friction0 to be #Friction1
			1) `Friction[0] = Friction[1]
		2) Reduce #Friction0 for low-end #velocity 
			1) Require #VelLength to be less than our #FrictRate0 actuation multiplier
				1) `if VelLength <= FrictRate[0] * MaxSpeed:`
				2) Divide #VelLength by #MaxSpeed for the proportional value, then add #FrictRate1 to it before diving the sum by #FrictRate1 to accrue total multiplier for #FrictRate2. Multiply to #Friction0
					1) `Friction[0] *= (((VelLength / MaxSpeed ) + FrictRate[1] ) / FrictRate[1] ) * FrictRate[2]
	4) Just before `velocity` math
		1) call `func _friction`
		2) then create another #velocity adjustment that decreases by #Friction0 * #MaxSpeed, clamping to prevent reduction from being greater than current  #velocity
			1) `velocity -= clampf(Friction[0] * MaxSpeed, 0,  velocity.length()) * velocity.normalized()`
5) #BoostDecay
	3) Define #SpeedAccel #BoostDecay  as `global arrays` with 3 variables each
		1) `@export var BoostDecay = [0, .015, .8]`
		2) `@export var SpeedAccel = [1.0, 0, .01]`
	4) Set up #BoostDecay to activate
		1) Allow #BoostDecay to pass through `if -MoveInput.y > 0`
			1) `if -MoveInput.y > 0 or BoostDecay[0] > 0:`
		2) Increase #BoostDecay0 when #MoveInputY is greater than #BoostDecay0's effective value
			1) Inside `if -MoveInput.y > 0 or BoostDecay[0] > 0:` 
				1) `if -MoveInput.y / BoostDecay[2] >= BoostDecay[0]:`
			2) Inside `if -MoveInput.y / BoostDecay[2] >= BoostDecay[0]:`
				1) Increase #BoostDecay0 by #BoostDecay1 * #MoveInputY and apply `clampf` to prevent exceeding #MoveInputY
					1) `BoostDecay[0] += clampf(2 * BoostDecay[1] * -MoveInput.y, 0, -MoveInput.y - BoostDecay[0])`
				2) Set #SpeedAccel1 to #BoostDecay0 times #SpeedAccel2 
					1) ~~`SpeedAccel[1] = SpeedAccel[0]
					2) `SpeedAccel[1] = SpeedAccel[2] * BoostDecay[0]`
	5) Deactivate #BoostDecay 
		1) After `if -MoveInput.y / BoostDecay[2] >= BoostDecay[0]:`
			1) `else:
			2) Decrease #BoostDecay0 by #BoostDecay1, `clampf` by #BoostDecay0 
				1) `BoostDecay[0] -= clampf(BoostDecay[1], 0, BoostDecay[0])
			3) Set #SpeedAccel1 to #BoostDecay0 times #SpeedAccel2 & #BoostDecay2 
				1) `SpeedAccel[1] = SpeedAccel[2] * BoostDecay[0] * BoostDecay[2]
		2) Delete old #SpeedAccel code
			1) ~~`else:
				1) ~~`speedAccel[1] = 0`~~
### Adjustment Log
- [[2025-01-13]]
	- Added #BoostDecay
- [[2025-01-14]]
	- Utilizes two separate #velocity adjustments to calculate momentum with #Friction and acceleration with #SpeedAccel 
	- When [[Boost|BoostDecay]] isn't active, #BoostDir is amplified by #MoveInputY value
- [[2025-01-17]]
	- Scales #BoostDecay0 by #MoveInputY
- [[2025-01-23]]
	- #BoostDecay0 is now properly capped by #MoveInputY
- [[2025-03-12]]
	- #BoostDir is unlinked with acceleration and directly determines velocity direction
	- #SpeedAccel is controlled by #BoostDecay to determine velocity
	- #Momentum is now decreased by a Linear friction
- [[2025-03-21]]
	-  reduced #Friction at low-end #velocity
- [[2025-08-26]]
	- Use of `Vector2.from_angle(x)` over `Vector2(cos(x), sin(x))`
	- Use of `Input.get_axis(x, y)` over `Input.get_action_strength, ...`
	- separated `_friction()` to be an isolated function
- [[2025-08-27]]
	- separated `MoveInput` & `_boost()` to be isolated functions