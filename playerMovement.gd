extends Node2D

@export var speed = 300
@export var maxHealth = 120

var health = 120
var dash_timed_out
var dash_cooldown =  0.5
var dash_speed = 900

var velocity

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	pass

func dash():
	if (!dash_timed_out):
		dash_timed_out = true
		$Timer.start(dash_cooldown)
		speed = dash_speed
		$playerSprites.rotation_degrees = 90
		print("dash")

func _process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
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

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_timer_timeout():
	speed = 300
	dash_timed_out = false
	$playerSprites.rotation_degrees = 0
	
	
func _on_area_2d_body_entered(body):
	if (body.name.find("enemy")):
		health -= body.damage
		var direction = (body.position - position).normalized() * 100
		position = position - direction
