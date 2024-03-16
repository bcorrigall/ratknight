extends CharacterBody2D

@export var speed = 300
@export var health = 120

var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func start(pos):
	pass


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

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
