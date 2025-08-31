extends CharacterBody2D

#region Variables
# Boost
@export var MaxSpeed := 2000
@export var AccelRate := .01
var _BoostStorage := .0
@export var StorageGrowth := .04
@export var StorageDecay := .015
@export var StorageReleaseScaler = .8

# Friction
@export var Friction := .002
@export var BrakeFrictionMult := 5.0
@export var FrictReductionPoint := .2
## [Step Size, Step Strength]
@export var FrictReductionStep := [.04, .08]  

# Rotation
var _RotationSpeed := .0
@export var MaxRota := PI/24
@export var RotaAccelRate := .02
@export var RotaFriction := .01
@export var BrakeRotaFrictionMult := 4.0
@export var CounterSteerRate := .35
var RotaAccelModif := 1.0
@export var RotaModifDecay := .1

# Dodge
@export var DodgeSpeed := .75
@export var DodgeRotaAccel := 4.
# Crash && WallBounce
@onready var wallbounce_angle = $%WallbounceMarker.position.angle()
@export var BounceStrength := .3
@export var CrashSpeed := .2
## [0: Minimum, 1: Maximum]
@export var CrashTime := [.8, 1.6]
@export var CrashImmunity := [false, .6] # {0: isActive, 1: CrashTimerMult}
var _Crashed := false
#endregion

#region Functions
func _moveInput():
	if not _Crashed: 
		return Vector2(Input.get_axis("RotateLeft", "RotateRight"), Input.get_axis("Boost", "Back"))
	else:
		return Vector2(0, 0)

func _boost(YInput: float):
	YInput *= -1
	if YInput > 0 or _BoostStorage > 0:
		var StorageRelease: float = _boostStorage(YInput)
		return AccelRate * _BoostStorage * StorageRelease
	else:
		return 0

func _boostStorage(YInput: float):
	if YInput / StorageReleaseScaler >= _BoostStorage:
		_BoostStorage += clampf(StorageGrowth * YInput, 0, YInput - _BoostStorage)
		return 1
	else:
		_BoostStorage -= clampf(StorageDecay, 0, _BoostStorage)
		return StorageReleaseScaler

func _friction(VelLength):
	var TotalFriction := Friction
	if Input.is_action_pressed("Brake") and not _Crashed:
		TotalFriction *= BrakeFrictionMult
	if VelLength <= FrictReductionPoint * MaxSpeed:
		TotalFriction *= (((VelLength / MaxSpeed ) + FrictReductionStep[0] ) / FrictReductionStep[0] ) * FrictReductionStep[1] 
	
	return TotalFriction

func _rotationSpeed(XInput):
	var RotaAcceleration := RotaFriction # RotaAcceleration is being used as RotaFriction as RotaFriction is the default result anyways
	if Input.is_action_pressed("Brake") and not _Crashed:
		RotaAcceleration *= BrakeRotaFrictionMult
	if XInput != 0: 
		var CounterSteer = absf((_RotationSpeed / MaxRota ) - XInput) * CounterSteerRate
		RotaAcceleration = (RotaAcceleration * CounterSteer ) + (RotaAccelRate * RotaAccelModif )
		
	_RotationSpeed = lerpf(_RotationSpeed, XInput * MaxRota, clampf(RotaAcceleration, 0, 1))
		
	if RotaAccelModif != 1:
		RotaAccelModif -= clampf((RotaAccelModif - 1 ) * RotaModifDecay, 0, RotaAccelModif - 1)

func crash(CrashTimeScaler):
	if CrashImmunity[0]:
		return
	
	CrashImmunity[0] = true
	_Crashed = true
	var CrashTimer = lerpf(CrashTime[0], CrashTime[1], CrashTimeScaler)
	await get_tree().create_timer(CrashTimer, true, true).timeout
	_Crashed = false
	await get_tree().create_timer(CrashImmunity[1] * CrashTimer, true, true).timeout
	CrashImmunity[0] = false

func dodge(DodgeDir):
	if DodgeDir.normalized().is_zero_approx():
		DodgeDir = Vector2(0,-1)
	
	_BoostStorage = 0
	RotaAccelModif += RotaAccelRate * DodgeRotaAccel
	
	velocity = (velocity / 2 ) + MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)

func _collided(WallNormal):
	var Bounciness = BounceStrength
	var CollisionAngle = abs(pingpong(WallNormal.angle() - rotation, TAU) - PI)
	var Impact = velocity.length() / MaxSpeed * (1 - (CollisionAngle / (PI - wallbounce_angle ) ) )
	
	if CollisionAngle <= wallbounce_angle and Impact >= CrashSpeed:
		crash((Impact - CrashSpeed ) * (1 / (1 - CrashSpeed ) ))
	elif CollisionAngle >= wallbounce_angle:
		Bounciness *= (1 / BounceStrength)
		
	velocity = velocity.bounce(WallNormal) * Vector2(lerpf(1, Bounciness, abs(WallNormal.x)), lerpf(1, Bounciness, abs(WallNormal.y)))
#endregion

func _physics_process(_delta):
	#region Setup
	var VelLength = velocity.length()
	var MoveInput: Vector2 = _moveInput()
	#endregion
	
	#region Transform
	if Input.is_action_just_pressed("Dodge") and not _Crashed:
		dodge(Vector2(MoveInput.x, MoveInput.y).normalized())
	
	_rotationSpeed(MoveInput.x)
	rotate(_RotationSpeed)
	
	if VelLength != 0:
		var TotalFriction = _friction(VelLength)
		velocity -= velocity.normalized() * clampf(TotalFriction * MaxSpeed, 0, VelLength)
	var Acceleration: float = _boost(MoveInput.y)
	if Acceleration != 0:
		velocity = lerp(velocity, MaxSpeed * Vector2.from_angle(rotation), Acceleration)
	
	move_and_slide()
	if is_on_wall():
		_collided(get_wall_normal())
	#endregion
