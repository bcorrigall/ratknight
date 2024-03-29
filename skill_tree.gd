extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("level"):
		if (visible == false):
			visible = true
	if Input.is_action_pressed("escape"):
		if (visible == true):
			visible = false
