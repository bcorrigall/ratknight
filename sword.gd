extends Area2D

@onready var shape =$CollisionShape2D

func enable():
	shape.disabled =false
	print("weapon visivle")

func disable():
	shape.disabled =true
	
