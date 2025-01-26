extends Node2D

@export var WallBoostScale = .25 # {0: Fluctuating, 1: Multiplier}

@onready var ray_cast_l = $RayCastL
@onready var ray_cast_ml = $RayCastML
@onready var ray_cast_m = $RayCastM
@onready var ray_cast_mr = $RayCastMR
@onready var ray_cast_r = $RayCastR

signal WallBoosting(TotalBoost)

func _physics_process(_delta):
	if ray_cast_l.is_colliding() or ray_cast_ml.is_colliding() or ray_cast_m.is_colliding() or ray_cast_mr.is_colliding() or ray_cast_r.is_colliding():
		
		var TotalBoost = 1
		if ray_cast_l.is_colliding():
			TotalBoost += WallBoostScale
		if ray_cast_ml.is_colliding:
			TotalBoost += WallBoostScale
		if ray_cast_m.is_colliding():
			TotalBoost += WallBoostScale
		if ray_cast_mr.is_colliding():
			TotalBoost += WallBoostScale
		if ray_cast_r.is_colliding():
			TotalBoost += clampf(WallBoostScale, 0, 2 - TotalBoost)
		WallBoosting.emit(TotalBoost)
	
