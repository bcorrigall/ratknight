extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rat = get_node("../theRat")
	var level = rat.level
	$CurrentLevel.text = str(level)
