extends CanvasLayer

@onready var skilltree= $SkillTree
@onready var player=$"../theRat"
@onready var pow_animation=$pow_icon

func _input(event):
	if event.is_action_pressed("level"): #new close and open fuction
		if skilltree.isOpen:
			skilltree.close()
		else:
			skilltree.open()
# Called when the node enters the scene tree for the first time.
func _ready():
	skilltree.close()
	update_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_level():
	$Level.text=str("Level: ")+str(player.level)


func _on_the_rat_levelup():
	update_level()

func update_exp():
	$ExperienceBar.update()
	$exp.text=str(player.experience)+str(" / ")+str(player.experience_to_next)


func _on_the_rat_exp():
	update_exp()


func _on_the_rat_playpow():
	
	if pow_animation.is_playing():
		print("replay!")
		pow_animation.stop()
		pow_animation.play("pow_timer")
	else:
		pow_animation.play("pow_timer")
	


func _on_the_rat_endpow():
	pow_animation.play("RESET")
	pass # Replace with function body.
