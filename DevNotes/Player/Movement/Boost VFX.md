![[Boost VFX.png]]
[[Boost VFX.kra]]

### Final Work
###### The VFX of boosting

#### Steps
1) `BoostSprite
	1) Inside [[PlayerScript.gd]]
		1) load reference to `BoostVFX`
			1) `@onready var boost_sprite = $VFX/BoostVFX
	2) Red
		1) Base on #SpeedAccel in relation to it's baseline
			1) Take current #SpeedAccel over #SpeedAccel2 and subtract from 1, making sure to `clampf` the subtracted amount
				1) `var RedFilterScaler = 1 - clampf((SpeedAccel[1] * SpeedAccel[0] / (SpeedAccel[2] * 1.5 )), 0, 1)`
			2) Call shader to adjust `RedFilter` by it's scaler
				1) `boost_sprite.material.set_shader_parameter("RedFilter", RedFilterScaler)
	3) Green
		1) Base on #velocity relative to #MaxSpeed & #rotation
			1) Find #velocityLength relative to #MaxSpeed 
				1) `var GreenFilterScaler = (velocity.length() / MaxSpeed )`
			2) Multiply by #velocityDir relative to #rotation
				1)  `* ((1 + velocity.normalized().dot(Vector2(cos(rotation), sin(rotation))) ) / 2 )
		2) Call shader to adjust `GreenFilter` to base amount minus scaled amount
			1) `boost_sprite.material.set_shader_parameter("GreenFilter", .8 - GreenFilterScaler * .8)
	4) Blue
		2) unimplented
2) `BoostParticle

### Adjustment Log
- [[2025-03-12]]
	- #GreenFilter now correlates with velocity direction
- [[2025-03-21]]
	- sprite draw order reduced below level objects