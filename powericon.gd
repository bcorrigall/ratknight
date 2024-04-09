extends TextureProgressBar
@onready var timer=$"../../theRat/boost"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gonetime=timer.get_time_left()
	value=gonetime*100/7
	pass
