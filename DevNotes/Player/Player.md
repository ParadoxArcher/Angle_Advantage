### The character the user plays as Emulating [[Data Wing]] movement

#### Components
- Core Movement
	- Difficult & floaty, top-down Movement, reminiscent of a spaceship in space
		- low-friction momentum
			- obfuscates timing of when a player needs to turn behind comprehension
		- acceleration locked to player rotation
			- requires the player to track their rotation to move
		- accelerated acceleration
			- further obfuscates a player's movement behind comprehension
		- Accelerated rotation
			- obfuscates the player's current and future rotation behind comprehension
- Movement options
	- Brakes
		- an option to enable tighter movements by removing momentum
	- Dodge
		- lightens the penalties afflicted by drastically slow acceleration, such as:
			- snail paced 0 to 60 problem
			- inability to react in any reasonable timeline
- Visuals
	- Player Sprite
	- Boost VFX
		- Sprite that becomes progressively larger and more active as accelerated acceleration becomes larger
		- Particle system to resemble soot particles in a flame6

### Adjustment Log
1) [[2025-01-23]]
	1) [[Boost VFX]]
2) [[2025-01-24]]
	1) [[Wall Boost]]
3) [[2025-03-22]]
	1) `motion_mode` swapped from `grounded` to `floating`





![[PlayerMovement.gd]]