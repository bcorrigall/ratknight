extends TextureProgressBar

@onready var player=$"../../theRat"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update():
	value=player.experience*100/player.experience_to_next


