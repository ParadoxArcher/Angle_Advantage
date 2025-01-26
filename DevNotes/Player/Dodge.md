### Final Work
###### Description of contents

#### Steps
1) 
	1) a
	2) 
	3) 
		1) `func dodge(DodgeDir):
			1) BoostDir = Vector2(0,0)
			2) BoostDecay[0] = 0
			3) 
			4) RotaAccel[0] += RotaAccel[1] * DodgeRotaAccel
			5) 
			6) if DodgeDir.normalized().is_zero_approx():
				1) DodgeDir = Vector2(0,-1)
			7) velocity = MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)`

### Adjustment Log
- 
	- 
	 