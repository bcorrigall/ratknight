extends CharacterBody2D


@export var SPEED = 125
@export var health = 100
@export var maxhealth=100
@export var damage = 10

var playerposition
var targetposition

@onready var player = get_parent().get_node("theRat")
@export var Item = preload("res://item.tscn")
@onready var effects = $Effect
@onready var shake = get_parent().get_node("Camera2D")
@onready var deathAnimation= $death
@onready var movineAnimation= $AnimatedSprite2D
@onready var coli=$CollisionShape2D
@onready var coli2=$HurtBox/CollisionShape2D
@onready var HPbar=$HPbar


var jerk_time = 1
var jerk_lower_bound = -0.2
var jerk_upper_bound = 0.2
var noise = Vector2(randf_range(jerk_lower_bound, jerk_upper_bound), randf_range(jerk_lower_bound, jerk_upper_bound))
var speed_boost = 0
var attacking = false
var deltax=0# for the shake
var isDead=false
var dropitem=false




@export var experience = 150

func _ready():
	$JerkTimer.start(jerk_time)
	deathAnimation.visible = false
	HPbar.visible=false
	randomize()


func _physics_process(delta):
	if isDead:return
	deltax=delta#store the value for shake
	playerposition = player.position
	targetposition = (playerposition - position).normalized()

	if global_position.distance_to(player.global_position) > 200:
		targetposition += noise.normalized()/2
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
	movineAnimation.visible=false
	effects.pause()
	deathAnimation.visible = true
	HPbar.visible=false
	coli.disabled=true
	coli2.disabled=true
	deathAnimation.play("default")


	

	

	

func get_hurt_star(number):
	health-=number

func _on_hurt_box_area_entered(area):
	if isDead:return
	if(area.name.match("Sword") and area.get_parent().visible or area.name.match("AttackArea")):
		get_damage(area)
	elif(area.name.match("theRatArea2D")):
		$AttackTimer.start(0.2)
		$AnimatedSprite2D.animation = "attack_side"
		
		attacking = true
	else:
		
		return

func shakey(area):
	if area is String:
		shake._hit(Vector2(0.950,0.950),Vector2(7,-9))
		shake.frameFreeze(0.1,0.09)#camera freeze
	elif(area.name.match("Sword")):
		shake._hit(Vector2(0.950,0.950),Vector2(7,-9))
		shake.frameFreeze(0.1,0.09)#camera freeze
	else:
		shake.shake_change()
		shake._process(deltax)
		shake.shake_false()
	
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
		
func _on_timer_timeout():
	effects.play("RESET")

func _on_jerk_timer_timeout():
	$JerkTimer.start(jerk_time)
	noise = Vector2(randf_range(jerk_lower_bound, jerk_upper_bound), randf_range(jerk_lower_bound, jerk_upper_bound))

func _on_attack_timer_timeout():
	attacking = false
	
func _on_death_animation_finished():
	deathAnimation.visible = false
	queue_free()
	pass

	
func FX_play(name):
	if name=="die":
		$SoundFX/die.play()
		print("die")
	elif name=="star":
		$SoundFX/star_hit.play()
		print("star")
	elif name=="hit":
		var type= randi() % 2
		print("hit")
		if(type==0):
			$SoundFX/Ehit_1.play()
			print("play hit1")
		else:
			$SoundFX/Ehit_2.play()
			print("play hit2")
	elif name=="fire":
		print("fire")
		$SoundFX/Fire_ball.play()
	else:
		print("error:" +str(name))
