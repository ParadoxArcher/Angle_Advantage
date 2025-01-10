extends CharacterBody2D

#region Variables
## Rotation Variables
var RotaSpeed : float = 0
@export var MaxRota = [TAU, TAU] # {0: Fluctuating, 1: BaseMaxRota}
@export var RotaAccel = [10.0, -.2, 10.0, 0.05] # {0: RotaAccel, 1: AccelEaseCurve, 2: RotaDecel, 3: DecelEaseCurve}

## Brake Variables
@export var BrakeDecel = [2.5, 30, 0.05] # {0: SpeedDecel, 1: RotaDecel[2], 2: DecelEaseCurve}

##Dodge Variables
@export var DodgeMaxSpeed = [1.5, 100, -4] # {0: MaxSpeedMultiplier, 1: MaxSpeedDecel, 2: EaseCurve}
@export var DodgeMaxRota = [2, PI/2, -4] # {0: MaxRotaMultiplier, 1: MaxRotaDecel, 2: EaseCurve}

## Boost Variables
@export var MaxSpeed = [1000, 1000] # {0: Fluctuating, 1: BaseMaxSpeed}
@export var SpeedAccel = [1, .5] # {0: Accel,  1: Decel}

## Display Variables
@export var MarkerSize = {"CenterGap": 50, "RotaSpeedGap": 75, "VelLength": .5, "NeutralLength": .35, "RotaSpeedLength": .5} #RotaSpeedGap left unimplemented, intended to slide rota_speed_display along neutral_display
@export var Markers = [true, false]
@onready var vel_display = $Sprites/VelDisplay
@onready var neutral_display = $Sprites/NeutralDisplay
@onready var rota_speed_display = $Sprites/RotaSpeedDisplay
#endregion

func _physics_process(delta):
	var MoveInput = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Boost") - Input.get_action_strength("Brake"))
	var AccelRate
	var RotaRate
	
	#region Brake
	var isBraking = false
	if MoveInput.y <= -.75:
		isBraking = true
	#endregion
	
	#region Rotation Rate
	if MoveInput.x != 0:
		RotaRate = [RotaAccel[0], RotaAccel[1]] #RotaAccel
	elif not isBraking:
		RotaRate = [RotaAccel[2], RotaAccel[3]] #BaseRotaDecel
	else:
		RotaRate = [BrakeDecel[1], BrakeDecel[2]] #BrakeRotaDecel
	#endregion

	#region Boost
	var BoostDir = Vector2(0, 0)
	if MoveInput.y > 0: 
		BoostDir = Vector2(cos(rotation), sin(rotation))
		AccelRate = SpeedAccel[0] #SpeedAccel
	elif not isBraking:
		AccelRate = SpeedAccel[1] #BaseSpeedDecel
	else:
		AccelRate = BrakeDecel[0] #BrakeSpeedDecel
	#endregion

	#region Dodge
	var DodgeDir = Vector2(Input.get_action_strength("RotateRight") - Input.get_action_strength("RotateLeft"), Input.get_action_strength("Brake") - Input.get_action_strength("Boost"))
	if Input.is_action_just_pressed("Dodge"):
		if DodgeDir.normalized().is_zero_approx():
			DodgeDir = Vector2(0,-1)
		MaxSpeed[0] = MaxSpeed[1] * DodgeMaxSpeed[0]
		MaxRota[0] = MaxRota[1] * DodgeMaxRota[0]
		velocity = MaxSpeed[0] * DodgeDir.rotated(rotation + PI/2)
	
	if MaxSpeed[0] != MaxSpeed[1] || MaxRota[0] != MaxRota[1]:
		MaxSpeed[0] = lerpf(MaxSpeed[0], MaxSpeed[1], ease(DodgeMaxSpeed[1], DodgeMaxSpeed[2]) * delta) # clamps used end lerps
		print(MaxSpeed)
		MaxRota[0] = lerpf(MaxRota[0], MaxRota[1], ease(DodgeMaxRota[1], DodgeMaxRota[2]) * delta) 
		print(MaxRota)
	#endregion

	#region WallBoost...
	
	#endregion
	
	#region Transform
	RotaSpeed = lerpf(RotaSpeed, MoveInput.x * MaxRota[0], ease(RotaRate[0], RotaRate[1]) * delta) # Rotation Acceleration
	rotate(RotaSpeed * delta)
	
	var TargetVel = BoostDir * MaxSpeed[0]
	velocity = lerp(velocity, TargetVel, AccelRate * delta)
	move_and_slide()
	#endregion
	
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
	
