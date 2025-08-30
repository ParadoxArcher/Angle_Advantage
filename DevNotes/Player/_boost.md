###### Accelerates the player relative to #rotation
- Pass in the #MoveInputY from `physics_process()` and invert it for simplicity
	- Input "Boost" is considered equivalent to "up" or "forward" which is marked `(0, -1)`, Inverting the #MoveInputY will set full "Boost" to `1`, AKA 100% "Boost"
- Check if either #MoveInputY or #BoostStorage, as determined by [[_boostDecay]], are active
	- `if` `True`, use a predef