### Final Work
###### Small bounce off wall when colliding and disable all actions shortly

#### Steps
1) Convert to KinematicBody2D physics
	2) Replace `move_and_slide` with `move_and_collide(velocity)`
2) Make [[Player]] bounce off walls
	1) Before `_physics_process(_delta):`
		1) Define #Bounce
			1) `@export var CollisionRebound = .3`
	2) Call `move_and_collide` as a variable instead, with a `safe_margin` of .7
		1) `var Collision = move_and_collide(velocity * _delta, false, .7, false)`
	3) When #Collision, invert #velocity by #Collision normal times #Bounce
		1) `if Collision:
			1) `velocity = velocity.bounce(Collision.get_normal()) * Bounce
3) Disable Movement
	1) Define variables #CrashTime and #Crashed
		2) `var Crashed = false
		3) `@export var CrashTime = 1.5
	2) Create and use `func crash():`
		1) `func crash():
		2) Inside `if Collision:` 
			1) `crash()
	3) Set #Crashed to true, `await` with `proccess_in_physics` set to `true`, and set #Crashed to `false`
		1) `Crashed = true
		2) `await get_tree().create_timer(CrashTime, true, true).timeout
		3) `Crashed = false`
	4) Apply to `if:` statements around #MoveInput, [[Brakes]], and [[Dodge]]
		1) #MoveInput 
			1) Before `func _physics_process(_delta):`
				1) Call #MoveInput
					1) `var MoveInput = Vector2(0, 0)
			2) `if not Crashed:
				1) `MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost") - Input.get_action_strength("Back"))
			3) `else:
				1) `MoveInput = Vector2(0, 0)`
		2) [[Brakes]]
			1) `if Input.is_action_pressed("Brake") and not Crashed:`
		3) [[Dodge]]
			1) `if Input.is_action_just_pressed("Dodge") and not Crashed:
4) Limit `crash` by #Collision direction and #velocity
	1) Before `func _physics_process(delta):`
		1) Define #CrashSpeed
			1) `@export var CrashSpeed = .4
	2) Inside `if Collision:` Get angle difference from #velocity and #Collision normal
		1) `var CollisionDot = velocity.normalized().dot(Collision.get_normal())
	3) #crash `if` #CollisionDot is <  - #CrashSpeed
		1) `if CollisionDot < -CrashSpeed:`
			1) `crash()`
	4) Multiply #CollisionDot  by #velocity length over #MaxSpeed1
		1) `if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed:`
5) `slide` player when velocity is lower than #CrashSpeed 
	1) move `velocity = velocity.bounce(Collision.get_normal()) * Bounce` inside ``if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed:``
		1) `if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed:`
			1) `velocity = velocity.bounce(Collision.get_normal()) * Bounce` 
	2) call `else` for `if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed:` and set #velocity to slide
6) Modify #Collision results by difference in #rotation to #Collision normal
	1) Prevent #crash from going off while looking away from wall
		1) Before `func _physics_process(_delta):` define #CrashAngle & #CrashSpeed
			1) `@export var CrashAngle = .3
			2) `@export var CrashSpeed = .35`
		2) Inside `if: collision` determine difference in #rotation to #Collision normal
			1) `var WallBounce = (Vector2(-cos(rotation), -sin(rotation)).dot(Collision.get_normal()) + 1 ) / 2
		3) Set #crash `if` #WallBounce > #CrashAngle
			2) `if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed and WallBounce > CrashAngle:`
				1) `crash()
	2) Reduce #velocity when looking away from wall
		1) Before `func _physics_process(_delta):` Define #Bounce as an array with a Minimum & Maximum
			1) `@export var Bounce = [.4, 1.0]
		2) Apply to #velocity when #Collision, according to #WallBounce 
			1) `velocity = velocity.bounce(Collision.get_normal()) * lerpf(Bounce[1], Bounce[0], WallBounce)
	3) Scale #CrashTime by #WallBounce & #rotation
		1) Before `func crash()` Define #CrashTime as an array with a Minimum & Maximum
			1) `@export var CrashTime = [.6, 1.8]
		2) Call #CrashTimeScaler input for `crash()` and `lerpf` #CrashTime by #CrashTimeScaler
			1) `func crash(CrashTimeScaler):
				1) `var CrashTimer = lerpf(CrashTime[0], CrashTime[1], CrashTimeScaler)
				2) `await get_tree().create_timer(CrashTimer, true,true).timeout`
		3) Insert #WallBounce * #velocity length / #MaxSpeed into #crash as #CrashTimeScaler
			1) `crash(WallBounce * (velocity.length() / MaxSpeed[0] )) `
7) #CrashImmunity
	1) Before `crash(CrashTimeScaler):` Define #CrashImmunity as an array of a `false` `bool` and `float
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
	- restructured collision to slide when moving along the wall