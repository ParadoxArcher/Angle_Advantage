###### Decelerate #velocity in any direction we aren't actively accelerating towards
- Creating a variable #TotalFriction, set it to a default equal to a predetermined #Friction, then;
	- `if` #VelLength is `<=` 
- Inside `_physics_process()`
	- `if` #velocity `!=` `0`
		- Create a #TotalFriction variable equal to `_friction()` 
		-  Subtract from #velocity; #TotalFriction times #MaxSpeed. `clampf` to ensure it isn't larger than #VelLength. Multiply by #velocity`.normalized()` to send in correct direction.