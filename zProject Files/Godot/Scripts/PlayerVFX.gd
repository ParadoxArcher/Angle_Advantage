extends Node2D

#region Variables
@onready var Player = get_parent()

@onready var boost_sprite = $%BoostSprite
@onready var boost_VFX_particle = $%BoostParticle2D

@export var DisplaysActive = [false, false]
@export var DisplaySize = {"CenterGap": 30, "velLength": .5, "boost_dirLength": .35, "rota_speedLength": .5}
@onready var Displays = {"velocity": $%VelDisplay, "boost_dir": $%BoostDirDisplay, "rota_speed": $%RotaSpeedDisplay}
#endregion

#region Functions
func _boostVFX():
	if Input.get_action_strength("Boost") > 0 or Player._BoostStorage > .4:
		boost_VFX_particle.emitting = true
	else:
		boost_VFX_particle.emitting = false
	
	var RedFilter = 1 - clampf((Player._BoostStorage / 1.5 ), 0, 1)
	boost_sprite.material.set_shader_parameter("RedFilter", RedFilter)

func _velocityVFX():
	var GreenFilterLeft = (Player.velocity.length() / Player.MaxSpeed ) * ((1 + Player.velocity.normalized().dot(Vector2.from_angle(Player.rotation - PI/6)) ) / 2 )
	#var GreenFilterRight = (Velocity.length() / Player.MaxSpeed ) * ((1 + Velocity.normalized().dot(Vector2.from_angle(Rotation - PI/6)) ) / 2 )
	boost_sprite.material.set_shader_parameter("GreenFilterLeft", GreenFilterLeft)
	boost_sprite.material.set_shader_parameter("GreenFilterRight", GreenFilterLeft)

func _movementVisualizerDisplay():
	if DisplaysActive[0]:
		if not DisplaysActive[1]:
			Displays["velocity"].visible = true
			Displays["boost_dir"].visible = true
			Displays["rota_speed"].visible = true
			DisplaysActive[1] = true
		
		Displays["velocity"].scale.x = Player.velocity.length() * DisplaySize["velLength"] / Player.MaxSpeed
		Displays["velocity"].position = Player.position + (((150 * Displays["velocity"].scale.x ) + DisplaySize["CenterGap"] ) * Player.velocity.normalized() ) # 150 vel_display's sprite's X.length/2
		Displays["velocity"].rotation = Player.velocity.angle()
		
		Displays["boost_dir"].scale.x = Player.BoostStorage * DisplaySize["boost_dirLength"]
		Displays["boost_dir"].position = Player.position + ((150 * Displays["boost_dir"].scale.x ) + DisplaySize["CenterGap"] ) * Vector2.from_angle(Player.rotation)
		Displays["boost_dir"].rotation = Player.rotation
		
		Displays["rota_speed"].scale.x = Player.RotationSpeed / Player.MaxRota * DisplaySize["rota_speedLength"]
		Displays["rota_speed"].position = Displays["boost_dir"].position + ((150 * Displays["rota_speed"].scale.x ) * Vector2.from_angle(Displays["boost_dir"].rotation + PI/2) )
		Displays["rota_speed"].rotation = Displays["boost_dir"].rotation + PI/2
	
	elif DisplaysActive [1]:
		Displays["velocity"].visible = false
		Displays["boost_dir"].visible = false
		Displays["rota_speed"].visible = false
		DisplaysActive[1] = false
#endregion

#region Processes
func _physics_process(_delta):
	_boostVFX()
	_velocityVFX()

func _process(_delta):
	_movementVisualizerDisplay()
#endregion
