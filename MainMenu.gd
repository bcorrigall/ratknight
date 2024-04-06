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
	Title_show_message("Game Over")
	$StartButton.hide()
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	$Label.text = "Rat Knight!"
	#$Label.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.set_text ("TRY AGAIN!")
	$StartButton.show()


func _on_message_timer_timeout():
	#$Message.hide()
	pass
