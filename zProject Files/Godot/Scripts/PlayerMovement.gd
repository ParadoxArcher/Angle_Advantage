extends CharacterBody2D

#region Variables
# Physics
@export var Mass := 5.0
@onready var CollisionShape = $CollisionPolygon2D
@onready var FirstShape = $CollisionPolygon2D.polygon
var _BodyArea : float

@export var Inertia := 3.0
var _RotaMomentum := .0
@export var RotaFriction := .01
@export var BrakeRotaFrictionMult := 4.0

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
@export var MaxRotationSpeed := PI/24
@export var AddTorqueRate := .02
@export var CounterSteerRate := .35
var _AddTorqueModif := 1.0
@export var AddTorqueModifDecay := .1

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
func set_Shape(BodyShape: PackedVector2Array):
	if BodyShape.size() < 3:
		print_debug("PlayerMovement.set_Shape().BodyShape.size() !>= 3")
		return
	
	for each in range(BodyShape.size()):
		_BodyArea += BodyShape[each].cross(BodyShape [(each + 1) % BodyShape.size()])
	_BodyArea /= 2
	
	if BodyShape != CollisionShape.polygon:
		CollisionShape.polygon = BodyShape

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

func _rotationAccel(XInput):
	var RotaAcceleration := RotaFriction # RotaAcceleration is being used as RotaFriction as RotaFriction is the default result anyways
	if Input.is_action_pressed("Brake") and not _Crashed:
		RotaAcceleration *= BrakeRotaFrictionMult
	if XInput != 0: 
		var CounterSteer = absf((_RotaMomentum / MaxRotationSpeed ) - XInput) * CounterSteerRate
		RotaAcceleration = (RotaAcceleration * CounterSteer ) + (AddTorqueRate * _AddTorqueModif )
		
	_RotaMomentum = lerpf(_RotaMomentum, XInput * MaxRotationSpeed, clampf(RotaAcceleration, 0, 1))
	
	if _AddTorqueModif != 1:
		_AddTorqueModif -= clampf((_AddTorqueModif - 1 ) * AddTorqueModifDecay, 0, _AddTorqueModif - 1)
	
	#return _RotaMomentum / Inertia
	

func _collided(_WallNormal, _CollisionVelocity):
	var _Bounciness = BounceStrength
	var _CollisionAngle = abs(pingpong(_WallNormal.angle() - rotation, TAU) - PI)
	var _Impact = _CollisionVelocity.length() / MaxSpeed * (1 - (_CollisionAngle / (PI - wallbounce_angle ) ) )
	
	if _CollisionAngle <= wallbounce_angle and _Impact >= CrashSpeed:
		crash((_Impact - CrashSpeed ) * (1 / (1 - CrashSpeed ) ))
	elif _CollisionAngle >= wallbounce_angle:
		_Bounciness *= (1 / BounceStrength)
		
	velocity = _CollisionVelocity.bounce(_WallNormal) * Vector2(lerpf(1, _Bounciness, abs(_WallNormal.x)), lerpf(1, _Bounciness, abs(_WallNormal.y)))

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
	_AddTorqueModif += AddTorqueRate * DodgeRotaAccel
	
	velocity = (velocity / 2 ) + MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)

#endregion

func _ready():
	set_Shape(FirstShape)

func _physics_process(_delta):
	#region Setup
	var _VelLength = velocity.length()
	var _MoveInput: Vector2 = _moveInput()
	#endregion
	
	#region Transform
	if Input.is_action_just_pressed("Dodge") and not _Crashed:
		dodge(Vector2(_MoveInput.x, _MoveInput.y).normalized())
	
	_rotationAccel(_MoveInput.x)
	rotate(_RotaMomentum)
	#rotate(_rotationSpeed())
	
	if _VelLength != 0:
		var _TotalFriction = _friction(_VelLength)
		velocity -= velocity.normalized() * clampf(_TotalFriction * MaxSpeed, 0, _VelLength)
	var _Acceleration: float = _boost(_MoveInput.y)
	if _Acceleration != 0:
		velocity = lerp(velocity, MaxSpeed * Vector2.from_angle(rotation), _Acceleration)
	
	move_and_slide()
	
	if is_on_wall():
		var _CollisionVelocity := velocity
		_collided(get_wall_normal(), _CollisionVelocity)
		
		for _each in get_slide_collision_count():
			var _CollisionLocal = to_local(get_slide_collision(_each).get_position())
			
			var _VelocityToTorqueAngle = sin(_CollisionLocal.rotated(rotation).angle_to(_CollisionVelocity))
			var _VelocityToTorque = _CollisionVelocity.length() * _CollisionLocal.length() * _VelocityToTorqueAngle
			print(_VelocityToTorque * (1 - Inertia))
			#_RotaMomentum += _VelocityToTorque / Inertia
			
			#var _RotationAccelToVelocityAngle = get_wall_normal().rotated(sign(_RotaMomentum) * PI/4 * abs(_RotaMomentum / MaxRotationSpeed ))
			#velocity += _RotationAccelToVelocityAngle * _CollisionLocal.length() * abs(_RotaMomentum) * 10#Inertia
	#endregion
