###### Decelerate #velocity in any direction we aren't actively accelerating towards
- Creating a variable #TotalFriction, set it to a default equal to a predetermined #Friction, then;
	- `if` #VelLength is `<=` #MaxSpeed times a #FrictionReductionPoint
		- determine the ratio of #VelLength over #MaxSpeed, then divide by #FrictReductionStep0 after adding it to the numerator in order to determine the amount of "steps", before we multiply this by the "step size" of #FrictReductionStep1 
	- `if` Input "Brake" is `true` `and` #Crashed is `false`, as determined by [[_crash]]
		- multiply #TotalFriction by #BrakeFrictionMult
- Inside `_physics_process()`
	- `if` #velocity `!=` `0`
		- Create a #TotalFriction variable equal to `_friction()` 
		-  Subtract from #velocity; #TotalFriction times #MaxSpeed. `clampf` to ensure it isn't larger than #VelLength. Multiply by #velocity`.normalized()` to send in correct direction.