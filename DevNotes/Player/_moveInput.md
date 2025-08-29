###### Uses Project Input map to interpret player inputs while not #Crashed
- Calls for a `Vector2` using `Input.get_axis` to compare:
	- #RotateLeft and #RotateRight
		- for `func _rotation()`
	- #Boost & #Back 
		- for `func _boost()`
- The `func` also checks the #Crashed `var`, as determined by  `func _crash()`
	- `if` `false`, the inputs are returned
	- `if` `true`, a `Vector2` set to `(0, 0)` is returned