extends CharacterBody2D

#region Variables
## Brake Variables
@export var BrakeDecelMult = [5, 3] # {0: SpeedDecelMult, 1: RotaDecelMult}
var isBraking = false

## CounterSteering
@export var CounterScaler = [1, .5] # {0: CounterAccel, 1: CounterSteer}

## Boost Variables
@export var MaxSpeed = [1000, 1000] # {0: Fluctuating, 1: BaseMaxSpeed} ## Beware DodgeMaxSpeed
@export var SpeedAccel = .025
@export var SpeedDecel = [.01, .01] # {0: Fluctuating,  1: Decel} ## Beware BrakeDecelMult
@export var BoostDecay = [0, .3, .005] # {0: Fluctuating,  1:BoostRelease, 2: DecayRate}
var BoostDir = Vector2(0, 0)
var AccelRate = 0

## Rotation Variables
var RotaSpeed : float = 0
@export var MaxRota = [PI/24, PI/24] # {0: Fluctuating, 1: BaseMaxRota} ## Beware DodgeMaxRota
@export var RotaAccel = .02
@export var RotaDecel = [.0075, .0075] # {0: Fluctuating, 1: BaseRotaDecel} ## Beware BrakeDecelMult
var RotaRate = 0

##Dodge Variables
@export var DodgeMaxSpeed = [1.3, .15] # {0: MaxSpeedMultiplier, 1: MaxSpeedDecel}
@export var DodgeMaxRota = [3, .25] # {0: MaxRotaMultiplier, 1: MaxRotaDecel}

## Markers Variables
@export var MarkerSize = {"CenterGap": 50, "RotaSpeedGap": 75, "VelLength": .5, "NeutralLength": .35, "RotaSpeedLength": .5} #RotaSpeedGap left unimplemented, intended to slide rota_speed_display along neutral_display
@export var Markers = [true, false]
@onready var vel_display = $Sprites/VelDisplay
@onready var neutral_display = $Sprites/NeutralDisplay
@onready var rota_speed_display = $Sprites/RotaSpeedDisplay
#endregion

func _physics_process(delta):
	var MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost") - Input.get_action_strength("Back"))
	
	#region isBraking
	if Input.is_action_pressed("Brake"):
		isBraking = true
	else:
		isBraking = false
	#endregion
	
	#region Boost
	if not isBraking:
		SpeedDecel[0] = SpeedDecel[1] 
	else:
		SpeedDecel[0] = SpeedDecel[1] * BrakeDecelMult[0]
		
	if MoveInput.y > 0  or BoostDecay[0] > 0:
		BoostDir = Vector2(cos(rotation), sin(rotation))
		var CounterAccel = BoostDir.dot(velocity.normalized()) * CounterScaler[0]
		AccelRate = SpeedAccel - SpeedDecel[0] * CounterAccel
		if MoveInput.y == 0:
			BoostDir *= (BoostDecay[1] * BoostDecay[0])
			BoostDecay[0] -= clampf(BoostDecay[2], 0, BoostDecay[0])
		else:
			BoostDecay[0] = 1
	else:
		BoostDir = Vector2(0, 0)
		AccelRate = SpeedDecel[0]
		
	print(AccelRate)
	#endregion

	#region Rotation
	if not isBraking:
		RotaDecel[0] = RotaDecel[1]
	else:
		RotaDecel[0] = RotaDecel[1] * BrakeDecelMult[1]
	
	if MoveInput.x != 0:
		var CounterSteer = absf((RotaSpeed / MaxRota[0] ) - MoveInput.x) * CounterScaler[1]
		RotaRate = RotaAccel + RotaDecel[0] * CounterSteer
	else:
		RotaRate = RotaDecel[0]
	#endregion

	#region Dodge
	var DodgeDir = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Back") - Input.get_action_strength("Boost"))
	
	if MaxSpeed[0] != MaxSpeed[1] || MaxRota[0] != MaxRota[1]:
		MaxSpeed[0] -= clampf((MaxSpeed[0] - MaxSpeed[1]) * DodgeMaxSpeed[1], 0, MaxSpeed[0] - MaxSpeed[1])
		MaxRota[0] -= clampf((MaxRota[0] - MaxRota[1]) * DodgeMaxRota[1], 0, MaxRota[0] - MaxRota[1])
	
	if Input.is_action_just_pressed("Dodge"):
		if DodgeDir.normalized().is_zero_approx():
			DodgeDir = Vector2(0,-1)
		MaxSpeed[0] = MaxSpeed[1] * DodgeMaxSpeed[0]
		MaxRota[0] = MaxRota[1] * DodgeMaxRota[0]
		velocity = MaxSpeed[0] * DodgeDir.rotated(rotation + PI/2)
	#endregion

	#region WallBoost...
	
	#endregion
	
	#region Transform
	RotaSpeed = lerpf(RotaSpeed, MoveInput.x * MaxRota[0], clampf(RotaRate, 0, 1)) # Rotation Acceleration
	rotate(RotaSpeed)
	
	var TargetVel = BoostDir * MaxSpeed[0]
	velocity = lerp(velocity, TargetVel, clampf(AccelRate, 0, 1))
	move_and_slide()
	#endregion
	
func _process(delta):
		#region Markers
	if Markers[0]:
		if not Markers[1]:
			vel_display.visible = true
			neutral_display.visible = true
			rota_speed_display.visible = true
			Markers[1] = true
		
		vel_display.scale.x = velocity.length() * MarkerSize["VelLength"] / MaxSpeed[1]
		vel_display.position = position + (((150 * vel_display.scale.x ) + MarkerSize["CenterGap"] ) * velocity.normalized() ) # 150 is the size of vel_display's sprite's X.length/2
		vel_display.rotation = velocity.angle()
		
		neutral_display.scale.x = MarkerSize["NeutralLength"]
		neutral_display.position = position + ((150 * neutral_display.scale.x ) + MarkerSize["CenterGap"] ) * Vector2(cos(rotation), sin(rotation))
		neutral_display.rotation = rotation
		
		rota_speed_display.scale.x = RotaSpeed * MarkerSize["RotaSpeedLength"] / MaxRota[1]
		rota_speed_display.position = neutral_display.position + ((150 * rota_speed_display.scale.x ) * Vector2(cos(neutral_display.rotation + PI/2), sin(neutral_display.rotation + PI/2)) )
		rota_speed_display.rotation = neutral_display.rotation + PI/2
	
	elif Markers [1]:
		vel_display.visible = false
		neutral_display.visible = false
		rota_speed_display.visible = false
		Markers[1] = false
	#endregion
