extends CharacterBody2D


@export var SPEED = 100.0
var Health = 100
var Damage = 10
var playerposition
var targetposition
@onready var player = get_parent().get_node("theRat")


func _physics_process(delta):
	
	playerposition = player.position
	targetposition = (playerposition - position).normalize()
	
	if position.distance_to(playerposition) > 3:
		move_and_slide(targetposition*SPEED)
		if targetposition.x > 0 and targetposition.y > 0:
			if targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = false
			elif targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "back"
				$AnimatedSprite2D.flip_h = false
		elif targetposition.x < 0 and targetposition.y > 0:
			if -targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = true
			elif targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "back"
				$AnimatedSprite2D.flip_h = false
		elif targetposition.x > 0 and targetposition.y < 0:
			if targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = false
			elif -targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "front"
				$AnimatedSprite2D.flip_h = false
		else:
			if -targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "side"
				$AnimatedSprite2D.flip_h = true
			elif -targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "front"
				$AnimatedSprite2D.flip_h = false
						
		$AnimatedSprite2D.play()
		
	else:
		$AnimatedSprite2D.stop()
			
