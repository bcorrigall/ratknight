extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$LEVELUP.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rat = get_node("../theRat")
	var level = rat.level
	var levelold = 1
	$CurrentLevel.text = str(level)
	if(level>levelold):
		$LEVELUP.show()
		$LevelUPTIME.start()


func _on_level_uptime_timeout():
	$LEVELUP.hide()
