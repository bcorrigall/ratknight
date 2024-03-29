extends Node2D

@export var w_name = "default"
@export var damage = 25
@export var rate_of_fire = 0.9
@export var type = "default"
@export var attack_scene = preload("res://Attack.tscn")

var attack
var timed_out = false
var rat

# Called when the node enters the scene tree for the first time.
func _ready():
	rat = get_parent()
	print(rat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("left_click") and !timed_out and not rat.in_dash and not rat.attack_hold:
		fire()

func fire():
	attack = attack_scene.instantiate()

	attack.damage = damage
	attack.position = global_position
	attack.direction = (get_global_mouse_position() - global_position).normalized()

	rat.attack_animation(attack.direction, rate_of_fire)
	get_parent().get_parent().add_child(attack)
	print(attack.position)
	print(position)

	timed_out = true
	$Timer.start(rate_of_fire)

func _on_timer_timeout():
	timed_out = false
