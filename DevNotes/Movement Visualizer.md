### Final Work
###### Visualizer of Movement characteristics

#### Steps
1) #velocity
	1) Before `func _process(_delta):` 
		1) Define #DisplaySize dictionary and key #CenterGap and #velLength 
			1) `@export var DisplaySize = {"CenterGap": 30, "velLength": .5}
		2) Define Dictionary #Displays and key velocity as #Sprites/velDisplay
			1) `@onready var Displays = {"velocity": $Sprites/VelDisplay}
	2) Inside `func _process(_delta):` 
		1) set #velDisplay scale.x proportional the #velocity amplitude over #MaxSpeed. Multiply by #velLength
			1) `Displays["velocity"].scale.x = velocity.length() * DisplaySize["velLength"] / MaxSpeed
		2) set #velDisplay position to #velocity .normalized() direction scaled by sprite size
			1) `Displays["velocity"].position = position + (((150 * Displays["velocity"].scale.x ) + DisplaySize["CenterGap"] ) * velocity.normalized() )
		3) set #velDisplay rotation to the angle of #velocity 
			1) `Displays["velocity"].rotation = velocity.angle()`
2) #BoostDir / #BoostDecay
	1) Before `func _process(_delta):` 
		2) Inside #DisplaySize dictionary key #boost_dirLength
			1) `@export var DisplaySize = {"boost_dirLength": .35`}
		3) Inside #Displays dictionary key boost_dir as #Sprites/Boost_dir 
			1) `@onready var Displays = {"boost_dir": $Sprites/BoostDirDisplay}
	2) Inside `func _process(_delta):` 
		1) set #boost_dir scale.x proportional to #BoostDecay. Multiply by #boost_dirLength
			1) `Displays["boost_dir"].scale.x = BoostDecay[0] * DisplaySize["boost_dirLength"]
		2) set #boos_dir position directly in front of [[Player]] with distance scaled by sprite size
			1) `Displays["boost_dir"].position = position + ((150 * Displays["boost_dir"].scale.x ) + DisplaySize["CenterGap"] ) * Vector2(cos(rotation), sin(rotation))
		3) set #boost_dir rotation to [[Player]] #rotation 
			1) `Displays["boost_dir"].rotation = rotation`
3) #RotaSpeed
	1) ) Before `func _process(_delta):` 
		2) Inside #DisplaySize dictionary key #rota_speedLength
			1) `@export var DisplaySize = {"rota_speedLength": .5`}
		3) Inside #Displays dictionary key rota_speed as #Sprites/rota_speed 
			1) `@onready var Displays = {"rota_speed": $Sprites/rota_speed}
	2) Inside `func _process(_delta):` 
		1) set #rota_speed scale.x proportional to #RotaSpeed. Multiply by #rota_speedLength 
			1) `Displays["rota_speed"].scale.x = RotaSpeed * DisplaySize["rota_speedLength"] / MaxRota
		2) set #boos_dir position directly in front of [[Player]] with distance scaled by sprite size
			1) `Displays["boost_dir"].position = position + ((150 * Displays["boost_dir"].scale.x ) + DisplaySize["CenterGap"] ) * Vector2(cos(rotation), sin(rotation))
		3) set #boost_dir rotation to [[Player]] #rotation 
			1) `Displays["boost_dir"].rotation = rotation`
4) Enable visibility

### Adjustment Log
- 
	- 
	 