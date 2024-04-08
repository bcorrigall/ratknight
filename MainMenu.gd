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


func game_over():
	$ScoreBoard.visible=true
	$gameover_music.play()
	var scoretween=get_tree().create_tween()

	await scoretween.tween_property($ScoreBoard/bigScoreRect/scoreRect/score, "text", "SOCRE:30!", 3).finished
	$ScoreBoard.visible=false
	
	
	
	


	
	Title_show_message("Game Over")
	var tweenword=get_tree().create_tween()
	tweenword.set_ease(Tween.EASE_IN_OUT)
	
	
	
	$StartButton.hide()
	# Wait until the MessageTimer has counted down.
	#await $MessageTimer.timeout
	await tweenword.tween_interval(0.5)
	await tweenword.tween_property($Label, "text", "Rat Knight!", 1.5).finished
	
	
	#$Label.text = "Rat Knight!"
	# Make a one-shot timer and wait for it to finish.
	$StartButton.set_text ("TRY AGAIN!")
	$StartButton.self_modulate.a=0
	$StartButton.show()
	var tween=get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	await tween.tween_property($StartButton, "self_modulate:a", 1, 1.5).finished
	tween.tween_callback($StartButton.queue_free)
	
	#await get_tree().create_timer(0.3).timeout




func _on_message_timer_timeout():
	#$Message.hide()
	pass
