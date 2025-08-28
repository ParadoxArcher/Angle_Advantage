extends CharacterBody2D

#region Movement Variables
## Friction
@export var Friction := [.002, .002]
@export var BrakeDecelMult := [4.0, 3.0]

## Boost
@export var MaxSpeed := 2000
@export var AccelRate := .01

## BoostDecay
var BoostStorage := .0
@export var DecayRate := .015
@export var DecayReleaseScaler = .8

 # {0: Fluctuating,  1: Base} ## Beware BrakeDecelMult
@export var FrictRate := [.2, .04, .08] # {0: Actuation, 1: StepSize, 2: StepStrength}

## Rotation Variables
@export var MaxRota := PI/24
@export var RotaAccel := [.02, .02, .1] # {0: Fluctuating, 1: BaseRotaAccel} ## Beware DodgeRotaAccel
@export var RotaDecel := [.01, .01] # {0: Fluctuating, 1: BaseRotaDecel, 2: DecayLerp} ## Beware BrakeDecelMult
@export var CounterSteerRate := .35
var RotaSpeed := .0
#endregion

#region Advanced Movement Variables
##Dodge Variables
@export var DodgeSpeed := .75
@export var DodgeRotaAccel := 4.

##Crash && WallBounce Variables
@onready var wallbounce_angle = $CollisionPolygon2D/WallbounceMarker.position.angle()
@export var BounceStrength := .3
@export var CrashSpeed := .2
@export var CrashTime := [.8, 1.6] # {0: Minimum, 1: Maximum}
@export var CrashImmunity := [false, .6] # {0: isActive, 1: CrashTimerMult}
var Crashed := false
#endregion

#region VFX
@onready var boost_sprite = $Boost/Sprite
@onready var boost_VFX_particle = $Boost/Sprite/Particle2D
@export var BounceVFX := [0, .05] # {0: fluctuating, 1: DecayRate}
#endregion

func _moveInput():
	if not Crashed:
		return Vector2(Input.get_axis("RotateLeft", "RotateRight"), Input.get_axis("Boost", "Back"))
	else:
		return Vector2(0, 0)

func _friction(VelLength):
	Friction[0] = Friction[1] # reset values
	RotaDecel[0] = RotaDecel[1]
	
	if VelLength <= FrictRate[0] * MaxSpeed: # Baseline Friction
		Friction[0] *= (((VelLength / MaxSpeed ) + FrictRate[1] ) / FrictRate[1] ) * FrictRate[2]
	
	if Input.is_action_pressed("Brake") and not Crashed:
		Friction[0] *= BrakeDecelMult[0]
		RotaDecel[0] *= BrakeDecelMult[1]

func _boost(YInput: float):
	YInput *= -1
	var ReleasedDecay: float = _boostDecay(YInput)
	if YInput > 0 or BoostStorage > 0:
		boost_VFX_particle.emitting = true
		return AccelRate * BoostStorage * ReleasedDecay
		
		 #VFX
		#var Particles = clampi(round(BoostDecay[0] * 5), 1, 5)
		#if Particles != boost_particle.amount:
		#	boost_particle.amount = Particles
	else:
		boost_VFX_particle.emitting = false

func _boostDecay(YInput: float):
	if YInput / DecayReleaseScaler >= BoostStorage:
		BoostStorage += clampf(2.5 * DecayRate * YInput, 0, YInput - BoostStorage)
		return 1
	else:
		BoostStorage -= clampf(DecayRate, 0, BoostStorage)
		return DecayReleaseScaler
		

func _rotationSpeed(XInput):
	if XInput != 0: 
		var CounterSteer = absf((RotaSpeed / MaxRota ) - XInput) * CounterSteerRate
		return (RotaDecel[0] * CounterSteer ) + RotaAccel[0]
	else:
		return RotaDecel[0]

func crash(CrashTimeScaler):
	if CrashImmunity[0]:
		return
	
	CrashImmunity[0] = true
	Crashed = true
	var CrashTimer = lerpf(CrashTime[0], CrashTime[1], CrashTimeScaler)
	await get_tree().create_timer(CrashTimer, true, true).timeout
	Crashed = false
	await get_tree().create_timer(CrashImmunity[1] * CrashTimer, true, true).timeout
	CrashImmunity[0] = false

func dodge(DodgeDir):
	if DodgeDir.normalized().is_zero_approx():
		DodgeDir = Vector2(0,-1)
	
	BoostStorage = 0
	
	RotaAccel[0] += RotaAccel[1] * DodgeRotaAccel
	
	velocity = (velocity / 2 ) + MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)

func _ready():
	PhysicsServer2D.body_set_param(get_rid(), PhysicsServer2D.BODY_PARAM_BOUNCE, BounceStrength)

func _physics_process(_delta):
	#region Setup
	var VelLength = velocity.length()
	var PlayerRot = rotation
	
	var MoveInput: Vector2 = _moveInput()
	_friction(VelLength)
	var Acceleration: float = _boost(MoveInput.y)
	var RotaRate: float = _rotationSpeed(MoveInput.x)
	#endregion
	
	if Input.is_action_just_pressed("Dodge") and not Crashed:
		dodge(Vector2(MoveInput.x, MoveInput.y).normalized())
	
	#region Transform
	RotaSpeed = lerpf(RotaSpeed, MoveInput.x * MaxRota, clampf(RotaRate, 0, 1)) # Rotation Acceleration
	rotate(RotaSpeed)
	
	velocity -= clampf(Friction[0] * MaxSpeed, 0, VelLength) * velocity.normalized() # Momentum & Friction
	velocity = lerp(velocity, MaxSpeed * Vector2.from_angle(PlayerRot), Acceleration) # Acceleration
	
	var RedFilter = 1 - clampf((Acceleration / 1.5 ), 0, 1) # VFX
	boost_sprite.material.set_shader_parameter("RedFilter", RedFilter)
	var GreenFilterLeft = (VelLength / MaxSpeed ) * ((1 + velocity.normalized().dot(Vector2.from_angle(PlayerRot - PI/6)) ) / 2 )
	var GreenFilterRight = (VelLength / MaxSpeed ) * ((1 + velocity.normalized().dot(Vector2.from_angle(PlayerRot - PI/6)) ) / 2 )
	boost_sprite.material.set_shader_parameter("GreenFilterLeft", GreenFilterLeft)
	boost_sprite.material.set_shader_parameter("GreenFilterRight", GreenFilterRight)
	
	if RotaAccel[0] != RotaAccel[1]:
		RotaAccel[0] -= clampf((RotaAccel[0] - RotaAccel[1] ) * RotaAccel[2], 0, RotaAccel[0] - RotaAccel[1])
	#endregion
	
	
	#region Collision --- Crash && WallBounce
	move_and_slide()
	if is_on_wall():
		var WallNormal = get_wall_normal()
		var BounceParam = PhysicsServer2D.body_get_param(get_rid(), PhysicsServer2D.BODY_PARAM_BOUNCE)
		var CollisionAngle = abs(pingpong(WallNormal.angle() - rotation, TAU) - PI)
		var Impact = velocity.length() / MaxSpeed * (1 - (CollisionAngle / (PI - wallbounce_angle ) ) )
		
		if CollisionAngle <= wallbounce_angle and Impact >= CrashSpeed:
			crash((Impact - CrashSpeed ) * (1 / (1 - CrashSpeed ) ))
		elif CollisionAngle >= wallbounce_angle:
			BounceParam *= (1 / BounceStrength)
			
		velocity = velocity.bounce(WallNormal) * Vector2(lerpf(1, BounceParam, abs(WallNormal.x)), lerpf(1, BounceParam, abs(WallNormal.y)))

	
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
		
		Displays["boost_dir"].scale.x = BoostStorage * DisplaySize["boost_dirLength"]
		Displays["boost_dir"].position = position + ((150 * Displays["boost_dir"].scale.x ) + DisplaySize["CenterGap"] ) * Vector2.from_angle(rotation)
		Displays["boost_dir"].rotation = rotation
		
		Displays["rota_speed"].scale.x = RotaSpeed / MaxRota * DisplaySize["rota_speedLength"]
		Displays["rota_speed"].position = Displays["boost_dir"].position + ((150 * Displays["rota_speed"].scale.x ) * Vector2.from_angle(Displays["boost_dir"].rotation + PI/2) )
		Displays["rota_speed"].rotation = Displays["boost_dir"].rotation + PI/2
	
	elif DisplaysActive [1]:
		Displays["velocity"].visible = false
		Displays["boost_dir"].visible = false
		Displays["rota_speed"].visible = false
		DisplaysActive[1] = false
	#endregion
