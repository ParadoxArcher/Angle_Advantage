### Final Work
###### Gives players an effective way to stop allowing us to drastically reduce base deceleration 

#### Steps
1)  as `global variables`
	1) Redefine #SpeedDecel & #RotaDecel as arrays, where #SpeedDecel1 & #RotaDecel1 are the base values
		1) `@export var SpeedAccel = [.01, .01]`
		2) `@export var RotaDecel = [.01, .01]`
	2) Call and Define #BrakeDecelMult as an array, where #BrakeDecelMult0 is for #SpeedDecel and #BrakeDecelMult1 is for #RotaDecel 
		1) `@export var BrakeDecelMult = [5.0, 3.0]`
2) After `MoveInput`
	1) Set variables while Input `Brake` is pressed
		1) `if Input.is_action_pressed("Brake"):
			1) `SpeedDecel[0] = SpeedDecel[1] * BrakeDecelMult[0]
			2) `RotaDecel[0] = RotaDecel[1] * BrakeDecelMult[1]
	2) Reset them to normal when not
		1) `else:
			1) `SpeedDecel[0] = SpeedDecel[1]
			2) `RotaDecel[0] = RotaDecel[1]
### Adjustment Log
- 