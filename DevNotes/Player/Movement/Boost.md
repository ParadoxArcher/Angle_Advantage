### When key is pressed, accelerate relative to rotation
#### Steps
1)  Define Input
	1) Project Settings --> Input Map --> "Boost" = W
	2) ![[Pasted image 20250111234514.png]]
2) Movement
	1) Define Speed
		1) ![[Pasted image 20250111235317.png]]
	2) Apply Speed to velocity when Input is Pressed 
		1) ![[Pasted image 20250112000602.png]]
	3) Activate CharacterBody2D velocity & physics
		1)  ![[Pasted image 20250111235849.png]]
3) Acceleration
	1) Accelerate velocity
		1) ![[Pasted image 20250112002928.png]]
	2) Create a rate of change and apply it
		1) ![[Pasted image 20250112001504.png]]
		2) ![[Pasted image 20250112002903.png]]
	3) Vary Acceleration based on acceleration or Deceleration
		1) ![[Pasted image 20250112002430.png]]
		2) ![[Pasted image 20250112002646.png]]
4) Boost direction based on Rotation
	1) Create variable outside physics process
		1) ![[Pasted image 20250112003332.png]]
	2) Define Boost Direction when trying to moving and reset when not
		1) ![[Pasted image 20250112003124.png]]
	3) Apply MaxSpeed to BoostDir and use the full Vector2 of velocity
		1) ![[Pasted image 20250112003537.png]]
5) Counter Acceleration
	1) Find difference between current velocity and Boost direction
		1) ![[Pasted image 20250112074603.png]]
	2) Apply to Acceleration