extends Node2D

var damage = 30
@onready var animation=$Sprite2D/AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
