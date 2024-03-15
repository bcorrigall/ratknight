extends Node2D

@export var w_name = "default"
@export var damage = 10
@export var rate_of_fire = 0.5
@export var type = "default"
@export var attack_scene = preload("res://Attack.tscn")

var attack
var timed_out = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("left_click") and !timed_out:
		fire()
		
func fire():
	print("weapon")
	var attack = attack_scene.instantiate()
	add_child(attack)
	

	attack.damage = damage
	attack.position = position
	attack.rotation = rotation
	print(attack.position)
	print(position)
	timed_out = true
	$Timer.start(rate_of_fire)

func _on_timer_timeout():
	timed_out = false
