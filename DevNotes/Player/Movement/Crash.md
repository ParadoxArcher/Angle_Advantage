### Final Work
###### Small bounce off wall when colliding and disable all actions shortly

#### Steps
1) Convert to KinematicBody2D physics
	1) Before `_physics_process(_delta):`
		1) Define #CollisionRebound
			1) `@export var CollisionRebound = .3`
	2) Swap `move_and_slide` with `move_and_collide`
		1) Delete `move_and_slide`
2) Make [[Player]] bounce off walls
	4) Call `move_and_collide` by defining it as a variable, with a `safe_margin` of .7
			1) `var Collision = move_and_collide(velocity * _delta, false, .7, false)`
		3) When #Collision, invert velocity by #Collision normal
			1) `if Collision:
				1) `velocity = velocity.bounce(Collision.get_normal())
3) 

### Adjustment Log
- [[2025-01-16]]
	- `move_and_slide` replaced with `move_and_collide` to be able to program other features such as the [[Crash]] or [[Crash]], requiring recreation of collision logic
	- Implemented basic `move_and_collide` functionality with velocity.bounce
	 