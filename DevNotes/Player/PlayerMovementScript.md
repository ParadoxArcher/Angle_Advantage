###### Handles basic player movement options

### `_moveInput()`
![[_moveInput#Uses Project Input map to interpret player inputs while not Crashed]]
### `_boost()`
![[_boost#Accelerates the player relative to rotation]]
### `_boostStorage()`
![[_boostStorage#A prerequisite of _boost that tapers the release value of MoveInputY]]
### `_friction()`
![[_friction#Decelerate velocity in any direction we aren't actively accelerating towards]]
### `_rotationSpeed()`
![[_rotationSpeed]]

### `_physics_process()`
- Uses #VelLength as a reference for #velocity`.length()
	- Passed into [[_friction]] as well