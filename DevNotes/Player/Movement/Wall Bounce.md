### Final Work
###### Bounce off wall when colliding with back end

#### Steps
1) Swap `move_and_slide` with `move_and_collide`
	1) Delete `move_and_slide`
	2) Call `move_and_collide` by defining it as a variable, with a `safe_margin` of .7
		1) `var Collision = move_and_collide(velocity * _delta, false, .7, false)`
	3) When #Collision, invert velocity by #Collision normal
		1) `if Collision:
			1) `velocity = velocity.bounce(Collision.get_normal())

### Adjustment Log
- [[2025-01-16]]
	- `move_and_slide` replaced with `move_and_collide` to be able to program other features such as the [[Wall Bounce]] or [[Crash]], requiring recreation of collision logic
	- Implemented basic `move_and_collide` functionality with velocity.bounce
	 