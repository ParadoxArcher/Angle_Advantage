extends Node2D
@onready var Player = get_parent()

@onready var boost_sprite = $%BoostSprite
@onready var boost_VFX_particle = $%BoostParticle2D

func _physics_process(_delta):
	var Velocity = Player.velocity
	var Rotation = Player.rotation
	
	if Player.BoostStorage > .5:
		boost_VFX_particle.emitting = true
	else:
		boost_VFX_particle.emitting = false
	
	var RedFilter = 1 - clampf((Player.BoostStorage / 1.5 ), 0, 1) # VFX
	boost_sprite.material.set_shader_parameter("RedFilter", RedFilter)
	
	var GreenFilterLeft = (Velocity.length() / Player.MaxSpeed ) * ((1 + Velocity.normalized().dot(Vector2.from_angle(Rotation - PI/6)) ) / 2 )
	#var GreenFilterRight = (Velocity.length() / Player.MaxSpeed ) * ((1 + Velocity.normalized().dot(Vector2.from_angle(Rotation - PI/6)) ) / 2 )
	boost_sprite.material.set_shader_parameter("GreenFilterLeft", GreenFilterLeft)
	boost_sprite.material.set_shader_parameter("GreenFilterRight", GreenFilterLeft)
	
func _process(_delta):
	pass
