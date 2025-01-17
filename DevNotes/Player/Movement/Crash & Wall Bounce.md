### Final Work
###### Small bounce off wall when colliding and disable all actions shortly

#### Steps
1) Convert to KinematicBody2D physics
	1) Before `_physics_process(_delta):`
		1) Define #CollisionRebound
			1) `@export var CollisionRebound = .3`
	2) Replace `move_and_slide` with `move_and_collide(velocity)`
2) Make [[Player]] bounce off walls
	1) Call `move_and_collide` as a variable instead, with a `safe_margin` of .7
		1) `var Collision = move_and_collide(velocity * _delta, false, .7, false)`
	2) When #Collision, invert velocity by #Collision normal
		1) `if Collision:
			1) `velocity = velocity.bounce(Collision.get_normal())
3) Disable Movement
	1) Define variables #CrashTime and #Crashed
		1) `var Crashed = false
		2) `@export var CrashTime = 1.5
	2) Create and use `func crash():`
		1) `func crash():
		2) Inside `if Collision:` 
			1) `crash()
	3) Set #Crashed to true, `await` a created timer, and set #Crashed to false
		1) `Crashed = true
		2) `await get_tree().create_timer(CrashTime).timeout
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
	2) Get angle difference from #velocity and #Collision normal
		1) `var CollisionDot = velocity.normalized().dot(Collision.get_normal())
	3) #crash `if` #CollisionDot is <  - #CrashSpeed
		1) `if CollisionDot < -CrashSpeed:`
			1) `crash()`
	4) Multiply #CollisionDot  by #velocity length over #MaxSpeed1
		1) `if CollisionDot * (velocity.length() / MaxSpeed[0] ) < -CrashSpeed:`

### Adjustment Log
- [[2025-01-16]]
	- `move_and_slide` replaced with `move_and_collide` to be able to program other features such as the [[Crash & Wall Bounce]] or [[Crash & Wall Bounce]], requiring recreation of collision logic
	- Implemented basic `move_and_collide` functionality with velocity.bounce
- [[2025-01-17]]
	- Implemented movement disable and it's limitations