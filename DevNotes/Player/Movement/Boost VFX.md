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
		1) Base size #MaxSpeed, only active with [[Boost]]
			1) a
				1) 
	3) Green
		1) Base on #velocity relative to #MaxSpeed & #rotation
			1) Find #velocityLength relative to #MaxSpeed 
				1) `var GreenFilterScaler = (velocity.length() / MaxSpeed )`
			2) Multiply by #velocityDir relative to #rotation
				1)  `* ((1 + velocity.normalized().dot(Vector2(-sin(rotation - PI/2), cos(rotation - PI/2))) ) / 2 )
		2) Call shader to adjust `GreenFilter` to base amount minus scaled amount
			1) `boost_sprite.material.set_shader_parameter("GreenFilter", .8 - GreenFilterScaler * .8)
	4) Blue
		2) unimplented
2) `BoostParticle

### Adjustment Log
- - [[2025-03-12]]
	- - #GreenFilter now correlates with velocity direction
	 