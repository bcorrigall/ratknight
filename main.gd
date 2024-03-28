extends Node
@onready var hud = $HUD

func _ready():
	hud.get_node("HeartContainer").setMaxHeart(get_node("theRat").maxHealth / 20)
	hud.get_node("HeartContainer").updateHearts(get_node("theRat").health / 20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
