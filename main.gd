extends Node
@onready var hud = $HUD
var heart_container
var skill_buttons

func _ready():
	heart_container = hud.get_node("HeartContainer")
	heart_container.setMaxHeart($theRat.maxHealth)
	heart_container.updateHearts($theRat.health)

	skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
	for button in skill_buttons:
		button.connect("add_skill", $theRat.on_skill_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	heart_container.setMaxHeart($theRat.maxHealth)
	heart_container.updateHearts($theRat.health)


func _on_skill_tree_closed(): #
	get_tree().paused = false
	pass # Replace with function body.


func _on_skill_tree_opened():
	get_tree().paused = true
	pass # Replace with function body.
