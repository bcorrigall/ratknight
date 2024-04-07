extends TextureProgressBar
@onready var timer=$"../../theRat/DashTimeout"
@onready var player=$"../../theRat"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.dash_timed_out:
		update()
	else:
		hide()
func update():
	var remaintime=player.dash_cooldown-timer.get_time_left()
	value=remaintime*100/player.dash_cooldown
