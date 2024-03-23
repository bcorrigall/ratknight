extends Node2D

@export var speed = 300
@export var maxHealth = 120

@onready var animations = $AnimationPlayer
@onready var weapon= $Weapon

var health = 120
var dash_timed_out
var dash_cooldown =  0.5
var dash_speed = 900

var velocity
var invincible = false
var dashTimeout = false

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	pass

func dash():
	if (!dash_timed_out and !dashTimeout):
		dash_timed_out = true
		$Timer.start(dash_cooldown)
		dashTimeout = true
		$dash_timeout.start(3)
		speed = dash_speed
		$playerSprites.rotation_degrees = 90
		print("dash")

func _process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
	weapon.visible=false
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("dash"):
		dash()
		
	if (velocity.y < 0):
		$playerSprites.animation = "back"
	elif (velocity.x < 0):
		$playerSprites.flip_h = true
		$playerSprites.animation = "right"
	elif (velocity.x > 0):
		$playerSprites.flip_h = false
		$playerSprites.animation = "right"
	else:
		$playerSprites.animation = "front"
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$playerSprites.play()
	else:
		$playerSprites.stop()
		$playerSprites.frame = 1
	
	if Input.is_action_pressed("attack_light"):
		weapon.visible=true
		attack_light()

	if Input.is_action_pressed("attack_spin"):
		weapon.visible=true
		attack_spin()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
func attack_light():
	if (velocity.y < 0): #back
		animations.play("attackBack")	
	elif(velocity.x<0): #left
		animations.play("attackLeft")
	elif(velocity.x>0):#right
		animations.play("attackRight")
	else:
		animations.play("attackDown")
		
func attack_spin():
	animations.play("attackSpin")
	


func _on_timer_timeout():
	speed = 300
	dash_timed_out = false
	$playerSprites.rotation_degrees = 0
	
	
func _on_area_2d_body_entered(body):
	if (body.name.find("enemy") and invincible == false and dash_timed_out == false):
		health -= body.damage
		var direction = (body.position - position).normalized() * 100
		position = position - direction
		$Invinciblilty.start(0.2)
		invincible = true


func _on_invinciblilty_timeout():
	invincible = false


func _on_dash_timeout_timeout():
	dashTimeout = false
