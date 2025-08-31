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
	- Bounces on the back end of player
		- offers another option for retaining momentum 
		- angle limitation provides difficulty and restriction to 
- Visuals
	- Player Sprite
		- Some combination of either:
			- Spaceship design
			- Simple geometric shape
	- Velocity VFX
		- shock wave effect
			- improves feedback on velocity
		- Position Trail
	- Boost VFX
		- Sprite that becomes progressively larger and more active as accelerated acceleration becomes larger
			- improves feedback on current acceleration
		- Particle system to resemble soot particles in a flame
			- variety in art
	- Action VFX
		- particles to represent bounce strength
		- sprite trail during dodges
			- grants greater feedback for all players when a dodge has been used
		- cooldown indicator for player dodges

### Adjustment Log
1) [[2025-01-23]]
	1) [[Boost VFX]]
2) [[2025-01-24]]
	1) [[Wall Boost]]
3) [[2025-03-22]]
	1) `motion_mode` swapped from `grounded` to `floating`





![[PlayerMovement.gd]]