### When key is pressed, move forward relative to rotation
#### Steps
1)  Define "Boost" Input
	1) Project Settings --> Input Map --> "Boost" = W
	2) ![[Pasted image 20250111234514.png]]
2) Move Forward
	1) Define Speed
		1) ![[Pasted image 20250111235317.png]]
	2) Apply Speed to velocity when Input is Pressed 
		1) ![[Pasted image 20250111235615.png]]
	3) Activate CharacterBody2D velocity & physics
		1)  ![[Pasted image 20250111235849.png]]
3) Accelerate Movement
	1) Progressively Accelerate 
	2) Create a rate of acceleration for acceleration & deceleration
		1) ![[Pasted image 20250112000136.png]]
	3) Vary Acceleration based on direction
4) Determine Direction
5) Apply Counter Acceleration