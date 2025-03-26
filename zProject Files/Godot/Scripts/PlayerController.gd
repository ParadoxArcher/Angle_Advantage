extends RigidBody2D

#region Basic Movement Variables
var MoveInput = Vector2(0, 0)

## Brake Variables
@export var BrakeDecelMult = [4.0, 3.0] # {0: SpeedDecelMult, 1: RotaDecelMult}

## Boost Variables
@export var MaxSpeed = 2000
@export var BoostDecay = [0, .015, .8] # {0: Final,  1:DecayRate, 2:ReleaseAccelScaler(cannot be 0)}
@export var AccelRate = [10, 0, 1.0] # {0: Base, 1: Current, 2: Multiplier} ## Beware WallBoostScale
@export var BaseDamp = 40

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
@export var DodgeSpeed = .75
@export var DodgeRotaAccel = 4.

##Crash && WallBounce Variables
@onready var wallbounce_angle = $CollisionPolygon2D/WallbounceMarker.position.angle()
@export var BounceStrength = .3
@export var CrashSpeed = .2
@export var CrashTime = [.8, 1.6] # {0: Minimum, 1: Maximum}
@export var CrashImmunity = [false, .6] # {0: isActive, 1: CrashTimerMult}
var Crashed = false
#endregion

#region VFX
@onready var boost_sprite = $Boost/Sprite
@onready var boost_particle = $Boost/Sprite/Particle2D
@export var BounceVFX = [0, .05] # {0: fluctuating, 1: DecayRate}
#endregion

func _ready():
	linear_damp = BaseDamp

func _physics_process(_delta):
	var PlayerRot = rotation
	
	if not Crashed:
		MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost") - Input.get_action_strength("Back"))
	else:
		MoveInput = Vector2(0, 0)
	
	
	RotaDecel[0] = RotaDecel[1]
		
	if Input.is_action_pressed("Brake") and not Crashed:
		linear_damp *= BrakeDecelMult[0]
		RotaDecel[0] *= BrakeDecelMult[1]
	else:
		linear_damp = BaseDamp
	
	if MoveInput.y > 0 or BoostDecay[0] > 0:
		AccelRate[1] = lerpf(0, MaxSpeed - linear_velocity.length(), .3) 
		#if MoveInput.y / BoostDecay[2] >= BoostDecay[0]:
			#BoostDecay[0] += clampf(2.5 * BoostDecay[1] * MoveInput.y, 0, MoveInput.y - BoostDecay[0])
			#AccelRate[1] = AccelRate[2] * BoostDecay[0]
			
	else:
		AccelRate[1] = 0
		#BoostDecay[0] -= clampf(BoostDecay[1], 0, BoostDecay[0])
		#AccelRate[1] = AccelRate[2] * BoostDecay[0] * BoostDecay[2]
	
	
		#region Rotation --- Defines rotation acceleration and it's momentum
	if MoveInput.x != 0: 
		var CounterSteer = absf((RotaSpeed / MaxRota ) - MoveInput.x) * CounterSteerRate
		RotaRate = RotaAccel[0] + RotaDecel[0] * CounterSteer
	else:
		RotaRate = RotaDecel[0]
	#endregion
	
	
	RotaSpeed = lerpf(RotaSpeed, MoveInput.x * MaxRota, clampf(RotaRate, 0, 1)) # Accelerated Rotation 
	rotate(RotaSpeed)
	
	add_constant_central_force(AccelRate[1] * Vector2(cos(PlayerRot), sin(PlayerRot)))
	#move_and_collide(linear_velocity)


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
	AccelRate[1] = 0
	
	RotaAccel[0] += RotaAccel[1] * DodgeRotaAccel
	
	if DodgeDir.normalized().is_zero_approx():
		DodgeDir = Vector2(0,-1)
	linear_velocity = MaxSpeed * DodgeSpeed * DodgeDir.rotated(rotation + PI/2)
