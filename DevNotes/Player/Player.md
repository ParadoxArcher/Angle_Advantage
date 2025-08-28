### The character the user plays as

#### Goals
Emulates movement style from [[Data Wing]] but in a combat-focused party game.

#### Steps
1) New scene "Player"
	1) `CharacterBody2D` node
		1) change `motion_mode` to `floating`
			1) set `wall_min_slide_angle` to `0`
			2) set `Collision.safe_margin` to `1`
	2) attach `Sprite2D` and link any Sprite
2) Create script `PlayerMovement` on the `RigidBody2D` to store all movement functions`
	1) [[Boost]]
		1) ![[Boost#Goals]]
	2) [[Rotation]]
		1) Set Input `RotateLeft` & `RotateRight`
	3) [[Movement Visualizer]]
		1) Under`PlayerChar`, add `Node` with 3 `Sprite2D` under it
	4) [[Brakes]]
		1) Set Input `Brake`
	5) [[Dodge]]
		1) Set Input `Dodge` & `Back`
	6) [[Crash & Wall Bounce]]
	7) [[Wall Boost]]
		1) Under`PlayerChar`, add `Node2D` with 5 `Raycast2D` under it which spread out well towards [[Boost VFX]]
		2) Added script to the `Node2D` called `WallBoostDetection
	8) [[Rotation Collision]] 
3) Visuals
	1) Create `Node2D` called `VFX`
	2) [[Boost VFX]]
		1) Under `VFX` create `Sprite2D` called `BoostVFX
		2) Under `BoostVFX` create `CPUParticles2D` called `BoostParticle`
	3) [[Avatar VFX]]

### Adjustment Log
1) [[2025-01-23]]
	1) [[Boost VFX]]
2) [[2025-01-24]]
	1) [[Wall Boost]]
3) [[2025-03-22]]
	1) `motion_mode` swapped from `grounded` to `floating`





![[PlayerMovement.gd]]