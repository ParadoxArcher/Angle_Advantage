### Final Work
###### Description of contents

#### Steps
1) 
	1) a
		1) `if Input.is_action_just_pressed("Dodge") and not Crashed:
			1) dodge(Vector2(MoveInput.x, -MoveInput.y).normalized())

		1) if SpeedAccel[0] != SpeedAccel[1]:
			1) SpeedAccel[0] -= clampf((SpeedAccel[0] - SpeedAccel[1] ) * SpeedAccel[2], 0, SpeedAccel[0] - SpeedAccel[1])
		2) if RotaAccel[0] != RotaAccel[1]:
			1) RotaAccel[0] -= clampf((RotaAccel[0] - RotaAccel[1] ) * RotaAccel[2], 0, RotaAccel[0] - RotaAccel[1])
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
	 