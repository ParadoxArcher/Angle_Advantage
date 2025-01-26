### Final Work
###### Gives players an effective way to stop allowing us to drastically reduce base deceleration 

#### Steps
1) Set up variables before `_physics_process(_delta):`
	1) Define #SpeedDecel & #RotaDecel as arrays, where #SpeedDecel1 & #RotaDecel1 are the base values
		1) `@export var SpeedAccel = [.01, .01]`
		2) `@export var RotaDecel = [.01, .01]`
	2) Call and Define #BrakeDecelMult as an array, where #BrakeDecelMult0 is for #SpeedDecel and #BrakeDecelMult1 is for #RotaDecel 
		1) `@export var BrakeDecelMult = [5.0, 3.0]`
2) After `MoveInput`
	1) Set variables when Input `Brake` is definined
	2) if Input.is_action_pressed("Brake") and not Crashed:
		SpeedDecel[0] = SpeedDecel[1] * BrakeDecelMult[0]
		RotaDecel[0] = RotaDecel[1] * BrakeDecelMult[1]
	else:
		SpeedDecel[0] = SpeedDecel[1]
		RotaDecel[0] = RotaDecel[1]
### Adjustment Log
- 
	- 
	 
