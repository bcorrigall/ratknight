extends Node2D

var speed = 700
var damage = 0
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	print("bullet")
	$Timer.start(0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(direction * speed * delta)
	
func _on_timer_timeout():
	queue_free()

