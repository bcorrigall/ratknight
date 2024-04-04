extends 'res://enemy.gd'

@export var attack_scene = preload("res://WizardBall.tscn")
var timed_out = false
var attack

func _ready():
	$JerkTimer.start(jerk_time)
	SPEED = 250
	health = 50
	damage = 15
	experience = 250

func _physics_process(delta):
	
	playerposition = player.position
	targetposition = (playerposition - position).normalized()

	if global_position.distance_to(player.global_position) > 400:
		targetposition += noise.normalized()/2
	elif global_position.distance_to(player.global_position) > 250:
		targetposition += noise.normalized()/2
		if (!timed_out):
			fire()
	else:
		var direction_to_player = (playerposition - global_position).normalized()
		if direction_to_player.dot(targetposition.normalized()) > 0: 
			targetposition *= -1


	if ((position.distance_to(playerposition) > 30) and !attacking):
		velocity = targetposition*(SPEED+speed_boost)
		move_and_slide()
		if targetposition.x > 0 and targetposition.y > 0:
			if targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "move_right"
			elif targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "move_front"
		elif targetposition.x < 0 and targetposition.y > 0:
			if -targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "move_left"
			elif targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "move_front"
		elif targetposition.x > 0 and targetposition.y < 0:
			if targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "move_right"
			elif -targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "move_back"
		else:
			if -targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "move_left"
			elif -targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "move_back"

		$AnimatedSprite2D.play()
		
	if health < 1:
		death()

func fire():
	attack = attack_scene.instantiate()

	attack.damage = damage
	attack.position = global_position
	attack.direction = (playerposition - global_position).normalized()

	get_parent().get_parent().add_child(attack)
	print(attack.position)
	print(position)

	timed_out = true

	$RangedTimer.start(4)

func _on_ranged_timer_timeout():
	timed_out = false
