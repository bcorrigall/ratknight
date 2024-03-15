extends Node2D

var speed = 400
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("bullet")
	$Timer.start(0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2(speed * delta, 0).rotated(rotation))
	
func _on_timer_timeout():
	queue_free()
