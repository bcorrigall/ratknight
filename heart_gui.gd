extends Panel
@onready var sprite =$Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(whole: int):
	sprite.frame = whole
	#if (whole == 0): sprite.frame=0
	#else: sprite.frame =4
