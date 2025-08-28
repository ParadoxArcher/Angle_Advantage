extends CharacterBody2D

#region Movement Variables
## Boost
@export var MaxSpeed := 2000
@export var AccelRate := .01
@export var Friction := .002
@export var BrakeFrictionMult := 5.0
@export var FrictReductionPoint := .2
## [Step Size, Step Strength]
@export var FrictReductionStep := [.04, .08] 

## BoostDecay
var BoostStorage := .0
@export var DecayRate := .015
@export var DecayReleaseScaler = .8

## Rotation
var RotationSpeed := .0
@export var MaxRota := PI/24
@export var RotaAccelRate := .02
@export var RotaFriction := .01
@export var BrakeRotaFrictionMult := 4.0
@export var CounterSteerRate := .35
var RotaAccelModif := 1.0
@export var RotaModifDecay := .1
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
	var TotalFriction := Friction
	
	if VelLength <= FrictReductionPoint * MaxSpeed: # Baseline Friction
		TotalFriction *= (((VelLength / MaxSpeed ) + FrictReductionStep[0] ) / FrictReductionStep[0] ) * FrictReductionStep[1]
	
	if Input.is_action_pressed("Brake") and not Crashed:
		TotalFriction *= BrakeFrictionMult
	
	return TotalFriction

func _boost(YInput: float):
	YInput *= -1
	if YInput > 0 or BoostStorage > 0:		
		var ReleasedDecay: float = _boostDecay(YInput)
		return AccelRate * BoostStorage * ReleasedDecay
	else:
		return 0

func _boostDecay(YInput: float):
	if YInput / DecayReleaseScaler >= BoostStorage:
		BoostStorage += clampf(2.5 * DecayRate * YInput, 0, YInput - BoostStorage)
		return 1
	else:
		BoostStorage -= clampf(DecayRate, 0, BoostStorage)
		return DecayReleaseScaler

func _rotationSpeed(XInput):
	var RotaAcceleration := RotaFriction # RotaAcceleration is being used as RotaFriction as RotaFriction is the default result anyways
	if Input.is_action_pressed("Brake") and not Crashed:
		RotaAcceleration *= BrakeRotaFrictionMult
	if XInput != 0: 
		var CounterSteer = absf((RotationSpeed / MaxRota ) - XInput) * CounterSteerRate
		RotaAcceleration = (RotaAcceleration * CounterSteer ) + (RotaAccelRate * RotaAccelModif )
		
	RotationSpeed = lerpf(RotationSpeed, XInput * MaxRota, clampf(RotaAcceleration, 0, 1))
		
	if RotaAccelModif != 1:
		RotaAccelModif -= clampf((RotaAccelModif - 1 ) * RotaModifDecay, 0, RotaAccelModif - 1)

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
	RotaAccelModif += RotaAccelRate * DodgeRotaAccel
	
	velocity = (velocity / 2 ) + MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)

func _boostVFX(YInput, VelLength):
	if YInput > 0 or BoostStorage > .5:
		boost_VFX_particle.emitting = true
	else:
		boost_VFX_particle.emitting = false
	
	var RedFilter = 1 - clampf((BoostStorage / 1.5 ), 0, 1) # VFX
	boost_sprite.material.set_shader_parameter("RedFilter", RedFilter)
	
	var GreenFilterLeft = (VelLength / MaxSpeed ) * ((1 + velocity.normalized().dot(Vector2.from_angle(rotation - PI/6)) ) / 2 )
	var GreenFilterRight = (VelLength / MaxSpeed ) * ((1 + velocity.normalized().dot(Vector2.from_angle(rotation - PI/6)) ) / 2 )
	boost_sprite.material.set_shader_parameter("GreenFilterLeft", GreenFilterLeft)
	boost_sprite.material.set_shader_parameter("GreenFilterRight", GreenFilterRight)

func _ready():
	PhysicsServer2D.body_set_param(get_rid(), PhysicsServer2D.BODY_PARAM_BOUNCE, BounceStrength)

func _physics_process(_delta):
	#region Setup
	var VelLength = velocity.length()
	var MoveInput: Vector2 = _moveInput()
	#endregion
	
	#region Transform
	if Input.is_action_just_pressed("Dodge") and not Crashed:
		dodge(Vector2(MoveInput.x, MoveInput.y).normalized())
	
	_rotationSpeed(MoveInput.x)
	rotate(RotationSpeed)
	
	var TotalFriction = _friction(VelLength)
	var Acceleration: float = _boost(MoveInput.y)
	
	velocity -= clampf(TotalFriction * MaxSpeed, 0, VelLength) * velocity.normalized() # Momentum & Friction
	velocity = lerp(velocity, MaxSpeed * Vector2.from_angle(rotation), Acceleration) # Acceleration
	#endregion
	
	#region Collision --- Crash && WallBounce
	move_and_slide()
	if is_on_wall():
		var WallNormal = get_wall_normal()
		var BounceParam = PhysicsServer2D.body_get_param(get_rid(), PhysicsServer2D.BODY_PARAM_BOUNCE)
		print(BounceParam)
		var CollisionAngle = abs(pingpong(WallNormal.angle() - rotation, TAU) - PI)
		var Impact = velocity.length() / MaxSpeed * (1 - (CollisionAngle / (PI - wallbounce_angle ) ) )
		
		if CollisionAngle <= wallbounce_angle and Impact >= CrashSpeed:
			crash((Impact - CrashSpeed ) * (1 / (1 - CrashSpeed ) ))
		elif CollisionAngle >= wallbounce_angle:
			BounceParam *= (1 / BounceStrength)
			
		velocity = velocity.bounce(WallNormal) * Vector2(lerpf(1, BounceParam, abs(WallNormal.x)), lerpf(1, BounceParam, abs(WallNormal.y)))
	#endregion
	
	_boostVFX(-MoveInput.y, VelLength)


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
		
		Displays["rota_speed"].scale.x = RotationSpeed / MaxRota * DisplaySize["rota_speedLength"]
		Displays["rota_speed"].position = Displays["boost_dir"].position + ((150 * Displays["rota_speed"].scale.x ) * Vector2.from_angle(Displays["boost_dir"].rotation + PI/2) )
		Displays["rota_speed"].rotation = Displays["boost_dir"].rotation + PI/2
	
	elif DisplaysActive [1]:
		Displays["velocity"].visible = false
		Displays["boost_dir"].visible = false
		Displays["rota_speed"].visible = false
		DisplaysActive[1] = false
	#endregion
