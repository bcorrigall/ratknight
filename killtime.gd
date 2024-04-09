extends ProgressBar
@onready var timer=$"../../KillTimer"

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gonetime=10-timer.get_time_left()
	value=gonetime*100/10
	pass
