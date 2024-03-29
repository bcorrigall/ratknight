extends Node2D

var speed = 750
var rotation_speed = 6
var damage = 0
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	print("bullet")
	$Timer.start(0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(direction * speed * delta)
	rotate(rotation_speed * delta)

func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if(body.get_name().begins_with("Enemy")):
		print(body.health)
		body.health = body.health - damage
		print(body.health)
		queue_free()
	

