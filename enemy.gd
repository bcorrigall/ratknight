extends CharacterBody2D


@export var SPEED = 100
@export var health = 100
@export var damage = 5

var playerposition
var targetposition

@onready var player = get_parent().get_node("theRat")
@export var Item = preload("res://item.tscn")
@onready var effects = $Effect

var jerk_time = 1
var jerk_lower_bound = -0.2
var jerk_upper_bound = 0.2
var noise = Vector2(randf_range(jerk_lower_bound, jerk_upper_bound), randf_range(jerk_lower_bound, jerk_upper_bound))
var speed_boost = 0

@export var experience = 500

func _ready():
	$JerkTimer.start(jerk_time)

func _physics_process(delta):
	
	playerposition = player.position
	targetposition = (playerposition - position).normalized()

	if global_position.distance_to(player.global_position) > 150:
		targetposition += noise.normalized()
		speed_boost = 0
	else:
		speed_boost = 50


	if position.distance_to(playerposition) > 30:
		velocity = targetposition*(SPEED+speed_boost)
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
	randomize()
	var type = 1
	if(type == 1):
		print("yo")
		var mob = Item.instantiate()
		print(mob)
		get_parent().add_child(mob)
		mob.set_animation(type)

		mob.position = global_position
		player.earn_experience(experience)

	queue_free()


func _on_hurt_box_area_entered(area):
	if(area.name.match("Sword") or area.name.match("AttackArea")):
		get_damage()
	elif !area.name.match("AttackArea") :
		return
	
	
func get_damage():
	effects.play("gethurt")
	$Timer.start(0.4)
	#effects.play("RESET")
	if(health<=0):
		death()
		
func _on_timer_timeout():
	effects.play("RESET")

func _on_jerk_timer_timeout():
	$JerkTimer.start(jerk_time)
	noise = Vector2(randf_range(jerk_lower_bound, jerk_upper_bound), randf_range(jerk_lower_bound, jerk_upper_bound))
