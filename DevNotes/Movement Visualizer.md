### Final Work
###### Visualizer of Movement characteristics

#### Steps
1) #velocity
	1) Before `func _process(_delta):` 
		1) Define #DisplaySize dictionary and key #CenterGap and #velLength 
			1) `@export var DisplaySize = {"CenterGap": 30, "velLength": .5}
		2) Define Dictionary #Displays and key velocity as #Sprites/VelDisplay
			1) @onready var Displays = {"velocity": $Sprites/VelDisplay}
	2) inside `func _process(_delta):` set 
		1) `Displays["velocity"].scale.x = velocity.length() * DisplaySize["velLength"] / MaxSpeed
2) #BoostDir / #BoostDecay
	1) 
3) #RotaSpeed
4) Enable visibility

### Adjustment Log
- 
	- 
	 