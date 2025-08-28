extends CharacterBody2D

#region Variables
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

##Dodge
@export var DodgeSpeed := .75
@export var DodgeRotaAccel := 4.

##Crash && WallBounce
@onready var wallbounce_angle = $CollisionPolygon2D/WallbounceMarker.position.angle()
@export var BounceStrength := .3
@export var CrashSpeed := .2
@export var CrashTime := [.8, 1.6] # {0: Minimum, 1: Maximum}
@export var CrashImmunity := [false, .6] # {0: isActive, 1: CrashTimerMult}
var Crashed := false
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
		var Bounciness = BounceStrength
		var CollisionAngle = abs(pingpong(WallNormal.angle() - rotation, TAU) - PI)
		var Impact = velocity.length() / MaxSpeed * (1 - (CollisionAngle / (PI - wallbounce_angle ) ) )
		
		if CollisionAngle <= wallbounce_angle and Impact >= CrashSpeed:
			crash((Impact - CrashSpeed ) * (1 / (1 - CrashSpeed ) ))
		elif CollisionAngle >= wallbounce_angle:
			Bounciness *= (1 / BounceStrength)
			
		velocity = velocity.bounce(WallNormal) * Vector2(lerpf(1, Bounciness, abs(WallNormal.x)), lerpf(1, Bounciness, abs(WallNormal.y)))
	#endregion
