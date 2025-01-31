extends CharacterBody2D

#region Basic Movement Variables
var MoveInput = Vector2(0, 0)

## Brake Variables
@export var BrakeDecelMult = [5.0, 3.0] # {0: SpeedDecelMult, 1: RotaDecelMult}

## Boost Variables
@export var MaxSpeed = 2000
@export var BoostDecay = [0, .015, .8] # {0: Fluctuating,  1:DecayRate, 2:BoostRelease(cannot be 0)}
@export var SpeedAccel = [.01, .01, .15] # {0: Fluctuating, 1: Accel, 2: DecayLerp} ## Beware WallBoostScale
@export var SpeedDecel = [.001, .001] # {0: Fluctuating,  1: Decel} ## Beware BrakeDecelMult
var BoostDir = Vector2(0, 0)
var AccelRate = 0

## Rotation Variables
@export var MaxRota = PI/24
@export var RotaAccel = [.02, .02, .1] # {0: Fluctuating, 1: BaseRotaAccel} ## Beware DodgeRotaAccel
@export var RotaDecel = [.01, .01] # {0: Fluctuating, 1: BaseRotaDecel, 2: DecayLerp} ## Beware BrakeDecelMult
@export var CounterSteerRate = .35
var RotaSpeed = 0
var RotaRate = 0
#endregion

#region Advanced Movement Variables
##Dodge Variables
@export var DodgeSpeed = 1.
@export var DodgeRotaAccel = 4.

##Crash && WallBounce Variables
@export var Bounce = [.4, 1.0] # {0: Minimum, 1: Maximum}
@export var CrashAngle = .3
@export var CrashSpeed = .35
@export var CrashTime = [.6, 1.8] # {0: Minimum, 1: Maximum}
@export var CrashImmunity = [false, .6] # {0: isActive, 1: CrashTimerMult}
var Crashed = false
#endregion

#region VFX
@onready var boost_sprite = $VFX/BoostVFX
@onready var boost_particle = $VFX/BoostVFX/BoostParticle
@export var BounceVFX = [0, .05] # {0: fluctuating, 1: DecayRate}
#endregion

func _physics_process(_delta):
	#region Basic Movement
	#region Input
	if not Crashed:
		MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost") - Input.get_action_strength("Back"))
	else:
		MoveInput = Vector2(0, 0)
	#endregion
	
	#region Brakes --- Amplifies Deceleration	
	if Input.is_action_pressed("Brake") and not Crashed:
		SpeedDecel[0] = SpeedDecel[1] * BrakeDecelMult[0]
		RotaDecel[0] = RotaDecel[1] * BrakeDecelMult[1]
	else:
		SpeedDecel[0] = SpeedDecel[1]
		RotaDecel[0] = RotaDecel[1]
	#endregion
		
	#region Boost --- Determines movement application and delays it's deactivation
	if MoveInput.y > 0 or BoostDecay[0] > 0:
		var BoostDirAmp
		if MoveInput.y / BoostDecay[2] >= BoostDecay[0]:
			BoostDirAmp = MoveInput.y
			BoostDecay[0] += clampf(BoostDecay[1] * MoveInput.y, 0, MoveInput.y - BoostDecay[0])
			
			boost_sprite.material.set_shader_parameter("RedFilter", 1 - clampf((.5 * SpeedAccel[0]/SpeedAccel[1] ), 0, 1)) # VFX, Enable Boost Visual
			boost_particle.emitting = true
		else:
			BoostDirAmp = BoostDecay[0] * BoostDecay[2]
			BoostDecay[0] -= clampf(BoostDecay[1], 0, BoostDecay[0])
			
			boost_sprite.material.set_shader_parameter("RedFilter", 1 - clampf((.5 * BoostDecay[0] * SpeedAccel[0]/SpeedAccel[1] ), 0, 1)) # VFX, Decay Boost Visual
			boost_particle.emitting = false
		
		BoostDir = Vector2(cos(rotation), sin(rotation)) * BoostDirAmp
	else:
		boost_sprite.material.set_shader_parameter("RedFilter", 1) # VFX, Disable Boost Visual
		boost_particle.emitting = false
	#endregion
	
	#region Rotation --- Defines rotation acceleration and it's momentum
	if MoveInput.x != 0: 
		var CounterSteer = absf((RotaSpeed / MaxRota ) - MoveInput.x) * CounterSteerRate
		RotaRate = RotaAccel[0] + RotaDecel[0] * CounterSteer
	else:
		RotaRate = RotaDecel[0]
	#endregion
	#endregion
	
	#region Advanced Movement
	if Input.is_action_just_pressed("Dodge") and not Crashed: # Calls Dodge() to instantanteously set movement in direction relative to rotation
		dodge(Vector2(MoveInput.x, -MoveInput.y).normalized())
	#endregion
	
	#region Transform
	RotaSpeed = lerpf(RotaSpeed, MoveInput.x * MaxRota, clampf(RotaRate, 0, 1)) # Rotation Acceleration
	rotate(RotaSpeed)
	
	velocity = lerp(velocity, velocity.normalized(), SpeedDecel[0]) # Momentum
	velocity = lerp(velocity, BoostDir * MaxSpeed, SpeedAccel[0]) # Acceleration
	
	if SpeedAccel[0] != SpeedAccel[1]:
		SpeedAccel[0] -= clampf((SpeedAccel[0] - SpeedAccel[1] ) * SpeedAccel[2], 0, SpeedAccel[0] - SpeedAccel[1])
	if RotaAccel[0] != RotaAccel[1]:
		RotaAccel[0] -= clampf((RotaAccel[0] - RotaAccel[1] ) * RotaAccel[2], 0, RotaAccel[0] - RotaAccel[1])
	
	boost_sprite.material.set_shader_parameter("GreenFilter", .6 - clampf((velocity.length() / MaxSpeed * .6 ), 0, 1)) # VFX
	#endregion
	
	#region Collision --- Crash && WallBounce
	var Collision = move_and_collide(velocity * _delta, false, .7, false)
	if Collision:
		var CollisionDot = velocity.normalized().dot(Collision.get_normal())
		var WallBounce = (Vector2(-cos(rotation), -sin(rotation)).dot(Collision.get_normal()) + 1 ) / 2
		if CollisionDot * velocity.length() / MaxSpeed < -CrashSpeed:
			velocity = velocity.bounce(Collision.get_normal()) * lerpf(Bounce[1], Bounce[0], WallBounce)
			
			if WallBounce > CrashAngle:
				crash(WallBounce * velocity.length() / MaxSpeed)
			else:
				BounceVFX[0] = 1 - (velocity.length() / MaxSpeed)
			
		else:
			velocity = velocity.slide(Collision.get_normal())
	
	#if BounceVFX[0] > 0: # VFX Bounce effect
		#BounceVFX[0] += clampf(BounceVFX[1], 0, 1 - BounceVFX[0])
		#boost_sprite.material.set_shader_parameter("GreenFilter", clampf(BounceVFX[0], 0, 1))
	#endregion


#region Graphics Variables
##Markers Variables
@export var DisplaySize = {"CenterGap": 30, "velLength": .5, "boost_dirLength": .35, "rota_speedLength": .5}
@export var DisplaysActive = [false, false]
@onready var Displays = {"velocity": $Sprites/VelDisplay, "boost_dir": $Sprites/BoostDirDisplay, "rota_speed": $Sprites/RotaSpeedDisplay}
#endregion

func _process(_delta): 
	#region Markers
	if DisplaysActive[0]:
		if not DisplaysActive[1]:
			Displays["velocity"].visible = true
			Displays["boost_dir"].visible = true
			Displays["rota_speed"].visible = true
			DisplaysActive[1] = true
		
		Displays["velocity"].scale.x = velocity.length() * DisplaySize["velLength"] / MaxSpeed
		Displays["velocity"].position = position + (((150 * Displays["velocity"].scale.x ) + DisplaySize["CenterGap"] ) * velocity.normalized() ) # 150 is the size of vel_display's sprite's X.length/2
		Displays["velocity"].rotation = velocity.angle()
		
		Displays["boost_dir"].scale.x = BoostDecay[0] * DisplaySize["boost_dirLength"]
		Displays["boost_dir"].position = position + ((150 * Displays["boost_dir"].scale.x ) + DisplaySize["CenterGap"] ) * Vector2(cos(rotation), sin(rotation))
		Displays["boost_dir"].rotation = rotation
		
		Displays["rota_speed"].scale.x = RotaSpeed / MaxRota * DisplaySize["rota_speedLength"]
		Displays["rota_speed"].position = Displays["boost_dir"].position + ((150 * Displays["rota_speed"].scale.x ) * Vector2(cos(Displays["boost_dir"].rotation + PI/2), sin(Displays["boost_dir"].rotation + PI/2)) )
		Displays["rota_speed"].rotation = Displays["boost_dir"].rotation + PI/2
	
	elif DisplaysActive [1]:
		Displays["velocity"].visible = false
		Displays["boost_dir"].visible = false
		Displays["rota_speed"].visible = false
		DisplaysActive[1] = false
	#endregion

func crash(CrashTimeScaler):
	if not CrashImmunity[0]:
		CrashImmunity[0] = true
		Crashed = true
		var CrashTimer = lerpf(CrashTime[0], CrashTime[1], CrashTimeScaler)
		await get_tree().create_timer(CrashTimer, true, true).timeout
		Crashed = false
		await get_tree().create_timer(CrashImmunity[1] * CrashTimer, true, true).timeout
		CrashImmunity[0] = false
	else:
		pass

func dodge(DodgeDir):
	BoostDecay[0] = 0
	
	RotaAccel[0] += RotaAccel[1] * DodgeRotaAccel
	
	if DodgeDir.normalized().is_zero_approx():
		DodgeDir = Vector2(0,-1)
	velocity = MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)

func _on_wall_boost_detection_wall_boosting(TotalBoost):
	SpeedAccel[0] = TotalBoost * SpeedAccel[1]
