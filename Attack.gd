extends Node2D

var speed = 750
var rotation_speed = 6
var damage = 0
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("bullet")
	$Timer.start(0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(direction * speed * delta)
	rotate(rotation_speed * delta)

func _on_timer_timeout():
	queue_free()

func _on_attack_area_area_entered(area):
	print(area)
	if(area.get_name().begins_with("HurtBox")):
		var enemy = area.get_parent()
		#print("damage: "+str(damage))
		#print(enemy.health)
		if(damage==0):print("error: star damage is 0")
		enemy.get_hurt_star(damage)
		enemy.get_damage("star")
		#print(enemy.health)
		queue_free()
