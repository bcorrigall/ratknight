extends CanvasLayer

@onready var skilltree= $SkillTree

func _input(event):
	if event.is_action_pressed("level"): #new close and open fuction
		if skilltree.isOpen:
			skilltree.close()
		else:
			skilltree.open()
# Called when the node enters the scene tree for the first time.
func _ready():
	skilltree.close()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
