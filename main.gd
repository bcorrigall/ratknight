extends Node
@onready var hud = $HUD
var heart_container
var skill_buttons
var kill_number=0




func _ready():
	$Background.play()
	heart_container = hud.get_node("HeartContainer")
	heart_container.setMaxHeart($theRat.maxHealth)
	heart_container.updateHearts($theRat.health)
	
	$Item2.setConnor1()
	$Item3.setConnor2()
	$Item4.setConnor3()
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


func _on_the_rat_gameover():
	$Background.stop()
	pass # Replace with function body.


func _on_button_pressed():
	if($Thanks.visible==false):
		$Button.hide()
		$Thanks.show()
		$Label2.hide()
		$Item2.show()
		$Item3.show()
		$Item4.show()
	#elif($Thanks.visible==true):
		#$Button.show()
		#$Thanks.hide()
	pass # Replace with function body.
