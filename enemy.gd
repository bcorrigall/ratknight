extends CharacterBody2D


@export var SPEED = 100.0
@export var health = 100
@export var damage = 5
var playerposition
var targetposition
@onready var player = get_parent().get_node("theRat")
@onready var animations= $AnimationPlayer
@onready var effects = $Effect


func _physics_process(delta):
	
	playerposition = player.position
	targetposition = (playerposition - position).normalized()

	if position.distance_to(playerposition) > 30:
		velocity = targetposition*SPEED
		move_and_slide()
		if targetposition.x > 0 and targetposition.y > 0:
			if targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = false
			elif targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "front"
		elif targetposition.x < 0 and targetposition.y > 0:
			if -targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = true
			elif targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "front"
		elif targetposition.x > 0 and targetposition.y < 0:
			if targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = false
			elif -targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "back"
		else:
			if -targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = true
			elif -targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "back"

		$AnimatedSprite2D.play()

	else:
		$AnimatedSprite2D.stop()
		
	if health < 1:
		death()


func death():
	#animation stuff
	queue_free()


func _on_hurt_box_area_entered(area):
	if area==$HitBox:return
	#if area==:return
	print(area)
	print("hit")
	get_damage()
	
func get_damage():
	health-=damage*5
	effects.play("gethurt")
	$Timer.start(0.4)
	#effects.play("RESET")
	if(health<=0):
		death()
		
func _on_timer_timeout():
	effects.play("RESET")

