extends Area2D

@export var WallBoostScale = .25 # {0: Fluctuating, 1: Multiplier}

@onready var ray_cast_l = $RayCastL
@onready var ray_cast_ml = $RayCastML
@onready var ray_cast_m = $RayCastM
@onready var ray_cast_mr = $RayCastMR
@onready var ray_cast_r = $RayCastR

signal WallBoosting(TotalBoost)

on


func _on_body_entered(body):
	pass # Replace with function body.
