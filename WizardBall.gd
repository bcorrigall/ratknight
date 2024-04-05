extends Area2D

var speed = 300
var rotation_speed = 6
var damage
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

func _on_area_entered(area):
	if(area.get_name().begins_with("theRatArea2D")):
		queue_free()
