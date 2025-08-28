extends Node2D
@onready var Player = get_parent()

@onready var boost_sprite = $%Boost/BoostSprite
@onready var boost_VFX_particle = $Boost/BoostSprite/Particle2D

func _physics_process(delta):
	if Player.BoostStorage > .5:
		boost_VFX_particle.emitting = true
	else:
		boost_VFX_particle.emitting = false
	
	var RedFilter = 1 - clampf((Player.BoostStorage / 1.5 ), 0, 1) # VFX
	boost_sprite.material.set_shader_parameter("RedFilter", RedFilter)
	
	var GreenFilterLeft = (Player.velocity.length() / Player.MaxSpeed ) * ((1 + velocity.normalized().dot(Vector2.from_angle(rotation - PI/6)) ) / 2 )
	var GreenFilterRight = (Player.velocity.length() / Player.MaxSpeed ) * ((1 + velocity.normalized().dot(Vector2.from_angle(rotation - PI/6)) ) / 2 )
	boost_sprite.material.set_shader_parameter("GreenFilterLeft", GreenFilterLeft)
	boost_sprite.material.set_shader_parameter("GreenFilterRight", GreenFilterRight)
	
func _process(delta):
	pass
