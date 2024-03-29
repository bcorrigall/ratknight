extends Node2D

@export var speed = 400
@export var maxHealth = 120

@onready var animations = $AnimationPlayer
@onready var weapon= $Weapon

var health = 120
var trap_slowdown = 1

var knockback_pos= Vector2.ZERO
var can_control = true

var velocity
var invincible = false

var attacking = false

var attack_hold = false
var attack_cooldown = 0.45
var attack_direction

var dash_direction = Vector2.ZERO
var dash_cooldown = 3
var dash_time = 0.5
var in_dash = false
var dash_timed_out = false
var dash_speed = 800

var invincibility_time = 0.15

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	pass
	
func attack_animation(direction, cooldown):
	attack_direction = rad_to_deg(direction.angle())
	attacking = true
	$AttackTimeout.start(attack_cooldown)

func dash():
	if (!in_dash and !dash_timed_out):
		in_dash = true
		$Dash.start(dash_time)
		speed = dash_speed
		dash_timed_out = true
		$DashTimeout.start(dash_cooldown)
		
		if (dash_direction.y < 0):
			$playerSprites.animation = "dash_back"
		elif (dash_direction.x < 0):
			$playerSprites.flip_h = true
			$playerSprites.animation = "dash_side"
		elif (dash_direction.x > 0):
			$playerSprites.flip_h = false
			$playerSprites.animation = "dash_side"
		else:
			$playerSprites.animation = "dash_front"


func _process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
	if (attacking==false):
		weapon.disable()

	if(in_dash):
		velocity = dash_direction
	elif(attacking):
		if Input.is_action_pressed("move_right"):
			velocity.x += 0.25
		if Input.is_action_pressed("move_left"):
			velocity.x -= 0.25
		if Input.is_action_pressed("move_down"):
			velocity.y += 0.25
		if Input.is_action_pressed("move_up"):
			velocity.y -= 0.25

		print(attack_direction)
		if attack_direction > -45 and attack_direction <= 45:
			$playerSprites.animation = "attack_side"
			$playerSprites.flip_h = false
		elif attack_direction > 45 and attack_direction <= 135:
			$playerSprites.animation = "attack_front"
		elif attack_direction > 135 or attack_direction <= -135:
			$playerSprites.animation = "attack_side"
			$playerSprites.flip_h = true
		else:
			$playerSprites.animation = "attack_back"
		$playerSprites.play()
	else:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1


		if (velocity.y < 0):
			$playerSprites.animation = "move_back"
		elif (velocity.x < 0):
			$playerSprites.flip_h = true
			$playerSprites.animation = "move_side"
		elif (velocity.x > 0):
			$playerSprites.flip_h = false
			$playerSprites.animation = "move_side"
		elif(velocity.y > 0):
			$playerSprites.animation = "move_front"
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$playerSprites.play()
	elif(!attacking):
		if($playerSprites.animation == "move_side"):
			$playerSprites.animation = "idle_side"
		elif($playerSprites.animation == "move_back"):
			$playerSprites.animation = "idle_back"
		elif($playerSprites.animation == "move_front"):
			$playerSprites.animation = "idle_front"
		$playerSprites.frame = 0

	if(Input.is_action_pressed("dash") and velocity.length() > 0):
		dash_direction = velocity
		dash()

	if Input.is_action_pressed("attack_light"):
		weapon.enable()
		attack_light()

	if Input.is_action_pressed("attack_spin"):
		weapon.enable()
		attack_spin()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
func attack_light():
	if(!attacking):
		attacking = true
		$AttackTimeout.start(attack_cooldown)
		if (velocity.y < 0): #back
			animations.play("attackBack")
			attack_direction = -90
		elif(velocity.x<0): #left
			animations.play("attackLeft")
			attack_direction = 180
		elif(velocity.x>0):#right
			animations.play("attackRight")
			attack_direction = 0
		else:
			animations.play("attackDown")
			attack_direction = 90
		await animations.animation_finished
		weapon.disable()
		
func attack_spin():
	animations.play("attackSpin")
	await animations.animation_finished
	weapon.disable()
	
	
func _on_area_2d_body_entered(body):
	if (body.name.find("enemy") and invincible == false and in_dash == false):
		health -= body.damage
		var direction = (body.position - position).normalized() * 100
		position = position - direction
		
		print("hit")
		get_parent().hud.get_node("HeartContainer").updateHearts(health)
		$Invinciblilty.start(invincibility_time)
		invincible = true

	elif (body.name.find("trap")):
		pass
		health -= body.damage
		speed = 100
		$Timer.start(trap_slowdown)
		


func _on_dash_timeout():
	in_dash = false
	$playerSprites.position.x = 0
	speed = 400

func _on_invinciblilty_timeout():
	invincible = false

func _on_dash_timeout_timeout():
	dash_timed_out = false

func _on_attack_timeout_timeout():
	attacking = false
