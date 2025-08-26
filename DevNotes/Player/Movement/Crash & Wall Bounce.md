### Final Work
###### Small bounce off wall when colliding and disable all actions shortly

#### Steps
1) Make [[Player]] bounce off walls
	1) Just after `move_and_slide`
		1) When in contact with a wall...
			1) `if is_touching_wall():`
		2) Store the collision normal for optimization and legibility
			1) `var WallNormal = get_wall_normal()`
		3) Bounce velocity off the collision normal
			2) `velocity = velocity.bounce(WallNormal)
	2) Make Bounce potency modifiable
		1) `@export var` #BounceStrength
			1) `@export var BounceStrength = .4
		2) in `func _ready():`
			2) set `PhysicsServer2D.BODY_PARAM_BOUNCE`
				1) `PhysicsServer2D.body_set_param(get_rid(), PhysicsServer2D.BODY_PARAM_BOUNCE, BounceStrength)`
		3) modify `velocity.bounce()` by our parameter
			1) Store #BounceStrength for optimization and legibility
				1) `var BounceParam = PhysicsServer2D.body_get_param(get_rid(), PhysicsServer2D.BODY_PARAM_BOUNCE)
			2) Multiply `velocity.bounce()` by a `Vector2` where both the `x` and `y` values are `lerpf()` between `1` and our `BounceParam`, weighted by the `abs()` of the collision normal's `x` and `y` values, respectively
				1) `velocity = velocity.bounce(WallNormal) * Vector2(lerpf(1, BounceParam, abs(WallNormal.x)), lerpf(1, BounceParam, abs(WallNormal.y)))`
	3) Boost #BounceStrength when colliding with back of player model
		1) Set an actuation angle
			1) `@onready var wallbounce_angle = $CollisionPolygon2D/WallbounceMarker.position.angle()
				1) *this utilizes a Marker2D to determine the angle*
		2) Determine the angle difference between the [[Player]] and collision normal
			1) in a `pingpong()` function...
				1) subtract the [[Player]] `rotation` from our collision normal `.angle()`, wrapped around `TAU`
					1) `var CollisionAngle = (pingpong(WallNormal.angle() - rotation, TAU)`
			2) then Subtract the result by `PI` to wrap around the player before grabbing the `abs()` of the result
				1) `var CollisionAngle = abs(pingpong(WallNormal.angle() - rotation, TAU) - PI)`
		3) Execute, multiplying `BounceParam` by the inverse of #BounceStrength 
			1) `if CollisionAngle >= wallbounce_angle:
				1) `BounceParam *= (1 / BounceStrength)`
2) Crashing
	1) Setup
		1) Define  #CrashTime and #Crashed as `global variables`
			1) `var Crashed = false
			2) `@export var CrashTime = 1.5
		2) Create and use `func crash():`
			1) `func crash():
			2) Inside `if is_on_walls():` 
				1) limit by `CollisionAngle`
					1) `if CollisionAngle <= wallbounce_angle:`
						1) `crash()
		3) Inside `func crash():`, set #Crashed to true, `await` with `proccess_in_physics` set to `true`, then set #Crashed to `false`
			1) `Crashed = true
			2) `await get_tree().create_timer(CrashTime, true, true).timeout
			3) `Crashed = false`
		4) Apply to `if:` statements around #MoveInput and [[Brakes]]
			1) Call #MoveInput as `global variable`
				1) Before `func _physics_process(_delta):`
					1) `var MoveInput = Vector2(0, 0)
			2) Cancel #MoveInput functionality when #Crashed
				1) `if not Crashed:
					1) `MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost") - Input.get_action_strength("Back"))
				2) `else:
					1) `MoveInput = Vector2(0, 0)`
			3) [[Brakes]]
				1) `if Input.is_action_pressed("Brake") and not Crashed:`
	2) Scale `crash()` time by relative #velocity and `CollisionAngle`
		1) Set #CrashSpeed minimum
				1) `@export var CrashSpeed = .2
		2) Enable `CrashTimeScaler` to be accepted by `crash()`
			1) `func crash(CrashTimeScaler):`
		3) Determine and insert `CrashScaler`
			1) Multiply relative `velocity` by the effective `crash` angles
				1) `var Impact = velocity.length() / MaxSpeed * (1 - (CollisionAngle / (PI - wallbounce_angle ) ) )
			2) add #CrashSpeed to `CollisionAngle` filter for `Crash()`
				1) `if CollisionAngle <= wallbounce_angle and Impact >= CrashSpeed:`
			3) Insert `Impact` into `crash()`, scaled properly by #CrashSpeed`
				1) `crash((Impact - CrashSpeed ) * (1 / (1 - CrashSpeed ) ))
	3) Utilize `CrashTimeScaler` in `crash()`
		1) Redefine #CrashTime as an `array` for Min & Max
			1) `@export var CrashTime = [.8, 1.6]
		2) `lerpf()` `CrashTimer` between #CrashTime by `CrashTimeScaler
			1) `await get_tree().create_timer(CrashTimer, true, true).timeout
		3) 
	4) Setup #CrashImmunity
		1) Define #CrashImmunity as a `global array` of a `false` `bool` and `float
			1) `@export var CrashImmunity := [false, .6]
		2) Inside `crash(CrashTimeScaler):` `return` `if` #CrashImmunity0 is `true`
			1) `if CrashImmunity[0]:
				1) return
			2) `...`
		3) After `return` and before `await(CrashTimer)` set #CrashImmunity0 to `true`
			1) `CrashImmunity[0] = true
		4) After `Crashed = false` `Await` by #CrashImmunity1 * #CrashTimer with `process_in_physics` set to `true` before setting #CrashImmunity0 to `false`
			1) `await get_tree().create_timer(CrashImmunity[1] * CrashTimer, true, true).timeout
			2) `CrashImmunity[0] = false

### Adjustment Log
- [[2025-01-16]]
	- Implemented basic `move_and_collide` functionality with velocity.bounce (1-2)
- [[2025-01-17]]
	- Implemented movement disable and it's limitations (3-6)
- [[2025-01-24]]
	- restructured collision to slide when moving alongside the wall
- [[2025-03-22]]
	- Refactored
		- `move_and_collide` base converted to `move_and_slide` base
		- Uses angles for calculation over `dot` product of velocity and CollisionNormal
		- Each step is properly scaled from 0 to 1 as opposed to leaking portion of the value from previous step
		- no longer overrides `velocity.bounce()` with a slide collision, bounce property can be reduced without decreasing velocity in unrelated direction
		- Bounce Property is stored in `PhysicsServer2D.BODY_PARAM_BOUNCE`
- [[2025-08-26]]
	- Early Bypass for #CrashImmunity0 