### The character the user plays as

#### Goals
Emulates movement style from [[Data Wing]] but in a combat-focused party game.

#### Steps
1) Make Player Character
	1) new scene "PlayerChar"
	2) create `CharacterBody2D` named: "Player"
	3) attach `Sprite2D` and link any Sprite
2) Develop Movement
	1) Attach script to `Player` named: `PlayerScript
	2) [[Boost]]
		1) Set Input `Boost`
	3) [[Rotation]]
		1) Set Input `RotateLeft` & `RotateRight`
	4) [[Movement Visualizer]]
		1) Under`PlayerChar`, add `Node` with 3 `Sprite2D` under it
	5) [[Brakes]]
		1) Set Input `Brake`
	6) [[Dodge]]
		1) Set Input `Dodge` & `Back`
	7) [[Crash & Wall Bounce]]
	8) [[Wall Boost]]
		1) Under`PlayerChar`, add `Node2D` with 5 `Raycast2D` under it which spread out well towards [[Boost VFX]]
		2) Added script to the `Node2D` called `WallBoostDetection
	9) [[Rotation Collision]] 
3) Visuals
	1) [[Boost VFX]]
	2) [[Avatar VFX]]

### Adjustment Log
1) [[2025-01-23]]
	1) [[Boost VFX]]
2) [[2025-01-24]]
	1) [[Wall Boost]]