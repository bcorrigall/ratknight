extends CanvasLayer

var simultaneous_scene = preload("res://main.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu_music.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Title_show_message(text):
	$Label.text = text
	$Label.show()
	$MessageTimer.start()

func _on_start_button_pressed():
	start_effect()

func start_effect():
	$Panel.show()
	$Menu_music.stop()
	var tween=get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	$start_music.play() #play music
	await tween.tween_property($Panel, "color:a", 1, 1.25).finished
	tween.tween_callback($Panel.queue_free)
	#clean menu
	$StartButton.hide()
	$Label.hide()
	#delete menu
	get_node("/root/MainMenu").queue_free()
	get_tree().root.add_child(simultaneous_scene)


func update_EnemyKill(score:int):
	$ScoreBoard/bigScoreRect/scoreRect/EnemyKill/score.text=str(score)
	pass

func update_Damage(score:int):
	$ScoreBoard/bigScoreRect/scoreRect/Damage/score.text=str(score)

func update_HPS(score:int):
	$ScoreBoard/bigScoreRect/scoreRect/HPS/score.text=str(score)
func update_Boss(score:int):
	$ScoreBoard/bigScoreRect/scoreRect/boss/score.text=str(score)

func update_Total(score:int):
	$ScoreBoard/bigScoreRect/scoreRect/Total_Mark/score.text=str(score)
	
func update_Label(value:String):
	$Label.text=value

func update_Logs(value:int):
	$ScoreBoard/bigScoreRect/Logs.text="Logs:"+str(value)

func game_over():
	$ScoreBoard.visible=true
	$gameover_music.play()
	score_tween()
	


	
	
func score_tween():
	var scoretween=get_tree().create_tween()
	scoretween.parallel().tween_method(update_EnemyKill, 0, 3000, 1)
	scoretween.parallel().tween_method(update_Damage, 0, 400, 1)
	scoretween.parallel().tween_method(update_HPS, 0, 30, 1)
	scoretween.parallel().tween_method(update_Boss, 0, 2, 1)
	scoretween.tween_method(update_Total, 0, 99999, 1)
	$ScoreBoard/bigScoreRect/Logs.visible=true
	scoretween.tween_method(update_Logs, 0, 100, 1).set_delay(0.5).set_ease(Tween.EASE_IN_OUT)
	$ScoreBoard/bigScoreRect/Close_button.show()
	


func game_over_tween():
	Title_show_message("Game Over")
	var tweenword=get_tree().create_tween()
	tweenword.set_ease(Tween.EASE_IN_OUT)
	$StartButton.hide()
	tweenword.tween_method(update_Label, "Game Over", "Rat Knight!", 1.5)
	
	$StartButton.set_text ("TRY AGAIN!")
	$StartButton.self_modulate.a=0
	$StartButton.show()
	var tween=get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	await tween.tween_property($StartButton, "self_modulate:a", 1, 1.5).finished
	tween.tween_callback($StartButton.queue_free)
	
	
	pass	


func _on_message_timer_timeout():
	#$Message.hide()
	pass


func _on_close_button_pressed():
	$ScoreBoard.visible=false
	game_over_tween()
	pass # Replace with function body.
