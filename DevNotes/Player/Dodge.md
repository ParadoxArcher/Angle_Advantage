### Final Work
###### Description of contents

#### Steps
1) Instantiate movement
	1) Define #DodgeSpeed `global variables`
		1) `@export var DodgeSpeed = 1.
	2) Define `func dodge():` for global use and set #velocity to #MaxSpeed * #DodgeSpeed inside it
		1) `func dodge(DodgeDir):
			1) `velocity = MaxSpeed * DodgeSpeed`
	3) Call `Dodge()` when input is pressed,
		1) `if Input.is_action_just_pressed("Dodge"):`
			1) `dodge()`
2) Adjust movement by Input 
	1) Request #DodgeDir for `dodge():`
		1) `func dodge(DodgeDir):`
	2) Insert #MoveInput into `dodge()` call 
		1) `dodge(Vector2(MoveInput.x, -MoveInput.y).normalized())`
	4) Set #DodgeDir to a neutral direction when no #MoveInput 
		3) `if DodgeDir.normalized().is_zero_approx():
			1) `DodgeDir = Vector2(0,-1)
	5) Adjust #velocity math by #DodgeDir 
		1) `velocity = MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)
3) Increase #RotaAccel temporarily
		6) 
		8) if RotaAccel[0] != RotaAccel[1]:
			1) RotaAccel[0] -= clampf((RotaAccel[0] - RotaAccel[1] ) * RotaAccel[2], 0, RotaAccel[0] - RotaAccel[1])
	7) 
			3) BoostDecay[0] = 0
			4) 
			5) RotaAccel[0] += RotaAccel[1] * DodgeRotaAccel

4) [[Dodge]]
	1) `if Input.is_action_just_pressed("Dodge") and not Crashed:

### Adjustment Log
- 
	- 
	 