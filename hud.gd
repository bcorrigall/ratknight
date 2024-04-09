extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	skilltree.close()
	update_level()
	update_kill()
	update_exp()
	update_dash()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rat = get_node("../theRat")
	var level = rat.level
	var levelold = 1
	$CurrentLevel.text = str(level)
	if(level>levelold):
		$LEVELUP.show()
		$LevelUPTIME.start()


func _on_the_rat_levelup():
	update_level()

func update_exp():
	$ExperienceBar.update()
	$exp.text=str(player.experience)+str(" / ")+str(player.experience_to_next)

func update_dash():
	$dashBar.update()

func _on_the_rat_exp():
	update_exp()


func _on_the_rat_playpow():
	
	if pow_animation.is_playing():
		pow_animation.stop()
		pow_animation.play("pow_timer")
	else:
		pow_animation.play("pow_timer")
	


func _on_the_rat_endpow():
	#pow_animation.play("RESET")
	pass # Replace with function body.


func update_kill():
	if(player.killcomble>0):
		setKill()
	
		
func setKill():
	if !killtimer.is_stopped():
		killtimer.stop()
	kill_panel.show()	
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(kill_com,"scale",Vector2(1,1),0.3).from(Vector2(2,2))
	tween.parallel().tween_property(kill_com,"modulate",Color.TOMATO,0.3)
	tween.parallel().tween_property(kill_com,"modulate",Color('#fff381'),0.3).set_delay
	$killcomble/kill.text = 'KILL %s !!!' %player.killcomble
	killtimer.start()
	
	
func _on_the_rat_kill():
	update_kill()
	pass # Replace with function body.


func _on_kill_timer_timeout():
	player.killcomble=0
	kill_panel.hide()
	pass # Replace with function body.


func _on_the_rat_dash_cool():
	$dashBar.show()
	$dashBar.update()
	pass # Replace with function body.
