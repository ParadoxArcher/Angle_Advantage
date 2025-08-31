###### Handles #rotation acceleration and deceleration using #MoveInputX
- Create `var` #RotaAcceleration set to a predetermined default result of #RotaFriction
- `if` Input "Brake" is `true` `and` #Crashed is `false`, as determined by [[_crash]]
	- 