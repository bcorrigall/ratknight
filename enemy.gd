extends CharacterBody2D


@export var SPEED = 125
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
var attacking = false

@export var experience = 150

func _ready():
	$JerkTimer.start(jerk_time)

func _physics_process(delta):
	
	playerposition = player.position
	targetposition = (playerposition - position).normalized()

	if global_position.distance_to(player.global_position) > 200:
		targetposition += noise.normalized()
		speed_boost = 0
	else:
		speed_boost = 50


	if ((position.distance_to(playerposition) > 30) and !attacking):
		velocity = targetposition*(SPEED+speed_boost)
		move_and_slide()
		if targetposition.x > 0 and targetposition.y > 0:
			if targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "move_side"
				$AnimatedSprite2D.flip_h = false
			elif targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "move_front"
		elif targetposition.x < 0 and targetposition.y > 0:
			if -targetposition.x > targetposition.y:
				$AnimatedSprite2D.animation = "move_side"
				$AnimatedSprite2D.flip_h = true
			elif targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "move_front"
		elif targetposition.x > 0 and targetposition.y < 0:
			if targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "move_side"
				$AnimatedSprite2D.flip_h = false
			elif -targetposition.y > targetposition.x:
				$AnimatedSprite2D.animation = "move_back"
		else:
			if -targetposition.x > -targetposition.y:
				$AnimatedSprite2D.animation = "move_side"
				$AnimatedSprite2D.flip_h = true
			elif -targetposition.y > -targetposition.x:
				$AnimatedSprite2D.animation = "move_back"

		$AnimatedSprite2D.play()
		
	if health < 1:
		death()

func death():
	#animation stuff
	randomize()
	var type = randi_range(1,3)
	if(type == 1):
		var mob = Item.instantiate()
		print(mob)
		get_parent().add_child(mob)

		mob.position = global_position
		player.earn_experience(experience)

	queue_free()


func _on_hurt_box_area_entered(area):
	if(area.name.match("Sword") and area.get_parent().visible or area.name.match("AttackArea")):
		get_damage()
	elif(area.name.match("theRatArea2D")):
		$AttackTimer.start(0.2)
		$AnimatedSprite2D.animation = "attack_side"
		
		attacking = true
	else:
		return

func get_damage():
	effects.play("gethurt")
	$Timer.start(0.4)
	if(health <= 0):
		death()
		
func _on_timer_timeout():
	effects.play("RESET")

func _on_jerk_timer_timeout():
	$JerkTimer.start(jerk_time)
	noise = Vector2(randf_range(jerk_lower_bound, jerk_upper_bound), randf_range(jerk_lower_bound, jerk_upper_bound))

func _on_attack_timer_timeout():
	attacking = false
