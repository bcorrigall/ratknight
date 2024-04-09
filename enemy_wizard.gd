extends 'res://enemy.gd'

@export var attack_scene = preload("res://WizardBall.tscn")
@onready var w_movineAnimation= $w_AnimatedSprite2D
@onready var w_deathAnimation= $w_death
var timed_out = false
var attack
var running = false
var friend = false

func _ready():
	$JerkTimer.start(jerk_time)
	SPEED = 250
	maxhealth=50
	health = 50
	damage = 15
	experience = 250
	w_deathAnimation.visible = false
	HPbar.visible=false
	randomize()

func _physics_process(delta):
	if isDead:pass
	playerposition = player.position
	targetposition = (playerposition - position).normalized()
	if (running == true):
		var direction_to_player = (playerposition - global_position).normalized()
		if direction_to_player.dot(targetposition.normalized()) > 0: 
			targetposition *= -1
	else:
		if global_position.distance_to(player.global_position) > 400 :
			targetposition += noise.normalized()/2
		elif global_position.distance_to(player.global_position) > 250:
			targetposition += noise.normalized()/2
			if (!timed_out):
				fire()
		else:
			running = true
			$Runtimer.start(0.5)


	if ((position.distance_to(playerposition) > 30) and !attacking):
		velocity = targetposition*(SPEED+speed_boost)
		move_and_slide()
		if targetposition.x > 0 and targetposition.y > 0:
			if targetposition.x > targetposition.y:
				w_movineAnimation.animation = "move_right"
			elif targetposition.y > targetposition.x:
				w_movineAnimation.animation = "move_front"
		elif targetposition.x < 0 and targetposition.y > 0:
			if -targetposition.x > targetposition.y:
				w_movineAnimation.animation = "move_left"
			elif targetposition.y > -targetposition.x:
				w_movineAnimation.animation = "move_front"
		elif targetposition.x > 0 and targetposition.y < 0:
			if targetposition.x > -targetposition.y:
				w_movineAnimation.animation = "move_right"
			elif -targetposition.y > targetposition.x:
				w_movineAnimation.animation = "move_back"
		else:
			if -targetposition.x > -targetposition.y:
				w_movineAnimation.animation = "move_left"
			elif -targetposition.y > -targetposition.x:
				w_movineAnimation.animation = "move_back"

		w_movineAnimation.play()
		
	if health < 1:
		death()

func fire():
	if isDead:pass
	FX_play("fire")
	attack = attack_scene.instantiate()

	attack.damage = damage
	attack.position = global_position
	attack.direction = (playerposition - global_position).normalized()

	get_parent().get_parent().add_child(attack)
	print(attack.position)
	print(position)

	timed_out = true

	$RangedTimer.start(4)

func get_damage(area):
	if isDead:return
	effects.play("gethurt")
	shakey(area)
	$Timer.start(0.4)
	HPbar.visible=true
	HPbar.update()
	
	
	if(area is String):
		FX_play("star")
	elif area.name.match("Sword"):
		FX_play("hit")
	else:
		FX_play("star")
		print("else star play")
	if(health <= 0):
		death()

func _on_ranged_timer_timeout():
	timed_out = false

func death():
	#animation stuff
	if isDead:return
	
	print("isDead:"+str(isDead))
	FX_play("die")
	isDead=true
	var type = randf()*100
	type+=player.item_drop
	if dropitem==false:
		if(type >= 70):
			print("drop item")
			var mob = Item.instantiate()
			get_parent().add_child(mob)
			mob.set_animation(type)
			mob.position = global_position
			dropitem=true
		else:
			print("posi: "+str(type))
			dropitem=true
		player.earn_experience(experience)
		player.earn_kill(maxhealth)
	w_movineAnimation.visible=false
	effects.pause()
	w_deathAnimation.visible = true
	HPbar.visible=false
	coli.disabled=true
	coli2.disabled=true
	w_deathAnimation.play("default")
	print(w_deathAnimation.is_playing())

func _on_w_death_animation_finished():
	w_deathAnimation.visible = false
	queue_free()
	pass # Replace with function body.


func _on_runtimer_timeout():
	running = false
	pass # Replace with function body.


func _on_timer_timeout_2():
	effects.play("RESET")
	pass # Replace with function body.
