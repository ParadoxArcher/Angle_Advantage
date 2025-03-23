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
				1) subtract the [[Player]] `rotation` collision normal `.angle()` minus the [[Player]]`rotation` by `TAU`, then Subtract the result by `PI` to wrap it around
2) 
3) Disable Movement
	2) Define  #CrashTime and #Crashed as `global variables`
		2) `var Crashed = false
		3) `@export var CrashTime = 1.5
	3) Create and use `func crash():`
		1) `func crash():
		2) Inside `if Collision:` 
			1) `crash()
	4) Inside `func crash():`, set #Crashed to true, `await` with `proccess_in_physics` set to `true`, then set #Crashed to `false`
		1) `Crashed = true
		2) `await get_tree().create_timer(CrashTime, true, true).timeout
		3) `Crashed = false`
	5) Apply to `if:` statement around #MoveInput and [[Brakes]]
		1) Call #MoveInput as `global variable`
			1) Before `func _physics_process(_delta):`
				1) `var MoveInput = Vector2(0, 0)
		2) Cancel #MoveInput functionality when #Crashed
			3) `if not Crashed:
				1) `MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost") - Input.get_action_strength("Back"))
			4) `else:
				1) `MoveInput = Vector2(0, 0)`
		3) [[Brakes]]
			1) `if Input.is_action_pressed("Brake") and not Crashed:`
4) Limit `crash` by #Collision direction and #velocity
	1) Define #CrashSpeed as `global variable`
		1) `@export var CrashSpeed = .4
	2) Inside `if Collision:` Get angle difference from #velocity and #Collision normal
		1) `var CollisionDot = velocity.normalized().dot(Collision.get_normal())
	3) #crash `if` #CollisionDot is <  - #CrashSpeed
		1) `if CollisionDot < -CrashSpeed:`
			1) `crash()`
	4) Multiply #CollisionDot  by #velocity length over #MaxSpeed
		1) `if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed:`
5) Modify #Collision results by difference in #rotation to #Collision normal
	1) Prevent #crash from going off while looking away from wall
		1) Define #CrashAngle & #CrashSpeed  as `global variable`
			1) `@export var CrashAngle = .3
			2) `@export var CrashSpeed = .35`
		2) Inside `if: collision` determine difference in #rotation to #Collision normal
			1) `var WallBounce = (Vector2(-cos(rotation), -sin(rotation)).dot(Collision.get_normal()) + 1 ) / 2
		3) Set #crash `if` #WallBounce > #CrashAngle
			2) `if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed and WallBounce > CrashAngle:`
				1) `crash()
	2) Reduce #velocity when looking away from wall
		1) Define #Bounce as a `global array` to set Minimum & Maximum
			1) `@export var Bounce = [.4, 1.0]
		2) Apply to #velocity when #Collision, according to #WallBounce 
			1) `velocity = velocity.bounce(Collision.get_normal()) * lerpf(Bounce[1], Bounce[0], WallBounce)
	3) Scale #CrashTime by #WallBounce & #rotation
		1) Define #CrashTime as a `global array` to set Minimum & Maximum
			1) `@export var CrashTime = [.6, 1.8]
		2) Call #CrashTimeScaler input for `crash()` and `lerpf` #CrashTime by #CrashTimeScaler
			1) `func crash(CrashTimeScaler):
				1) `var CrashTimer = lerpf(CrashTime[0], CrashTime[1], CrashTimeScaler)
				2) `await get_tree().create_timer(CrashTimer, true,true).timeout`
		3) Insert #WallBounce * #velocity length / #MaxSpeed into #crash as #CrashTimeScaler
			1) `crash(WallBounce * (velocity.length() / MaxSpeed[0] )) `
6) #CrashImmunity
	1) Define #CrashImmunity as a `global array` of a `false` `bool` and `float
		1) `@export var CrashImmunity = [false, .6]
	2) Inside `crash(CrashTimeScaler):` pass the entire `func` `if` #CrashImmunity0 is `true`
		1) `if not CrashImmunity[0]:
			1) `...`
		2) `else:
			1) `pass`
	3) Inside `if not CrashImmunity[0]:` and before `await(CrashTimer)` set #CrashImmunity0 to `true`
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
	- `move_and_collide` based converted to `move_and_slide` base
	- Uses angles for calculation over `dot` product of velocity and CollisionNormal
	- Each step is properly scaled from 0 to 1 as opposed to leaking portion of the value from previous step
	- no longer overrides `velocity.bounce()` with a slide collision, bounce property can be reduced without decreasing velocity in unrelated direction
	- Bounce Property is stored in `PhysicsServer2D.BODY_PARAM_BOUNCE`