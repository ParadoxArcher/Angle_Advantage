### Final Work
###### Description of contents

#### Steps
1) Instantiate movement
	1) Define #DodgeSpeed `global variables`
		1) `@export var DodgeSpeed = 1.
	2) Define `func dodge():` for global use and set #velocity to #MaxSpeed * #DodgeSpeed inside it
		1) `func dodge(DodgeDir):
			1) `velocity = MaxSpeed * DodgeSpeed`
	3) Call `Dodge()` when input is pressed & not #Crashed 
		1) `if Input.is_action_just_pressed("Dodge") and not Crashed:`
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
3) Increase #RotaAccel temporarily and remove #BoostDecay when calling `dodge()`
	1) as `global variables`
		2) Redefine #RotaAccel as an array where #RotaAccel1 is the base value and #RotaAccel2 is the decay rate
			1) `@export var RotaAccel = [.02, .02, .1]
		3) Define #DodgeRotaAccel
			1) `@export var DodgeRotaAccel = 4.
	2) Inside `func dodge():` 
		1) Set #BoostDecay0 to 0
			1) `BoostDecay[0] = 0
		2) Increase #RotaAccel0 by #DodgeRotaAccel
			1) `RotaAccel[0] += RotaAccel[1] * DodgeRotaAccel`
	3) Inside `_physics_Process(_delta):` decay #RotaAccel0 by #RotaAccel2
		3) `if RotaAccel[0] != RotaAccel[1]:
			1) `RotaAccel[0] -= clampf((RotaAccel[0] - RotaAccel[1] ) * RotaAccel[2], 0, RotaAccel[0] - RotaAccel[1])
### Adjustment Log
- 
	- 
	 