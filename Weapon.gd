extends Node2D

@export var w_name = "default"
@export var damage = 25
@export var original_damage = 25
@export var rate_of_fire = 0.7
@export var type = "default"
@export var attack_scene = preload("res://Attack.tscn")

var weapon:Area2D

var attack
var timed_out = false
var rat

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if get_children().is_empty():return
	
	weapon = get_node("Sword")
	rat = get_parent()
	#print(rat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("left_click") and !rat.attacking and !timed_out and !rat.in_dash and !rat.attack_hold:
		fire()

func fire():
	var attacks = get_parent().extra_attacks + 1 
	timed_out = true
	rat.attack_star()
	var shootanimation=false
	while attacks > 0:
		attack = attack_scene.instantiate()

		attack.damage = damage + rat.damage_bonus
		attack.position = global_position
		attack.direction = (get_global_mouse_position() - global_position).normalized()
		if !shootanimation:
			shootanimation=true
			rat.attack_animation(attack.direction, rate_of_fire)
		get_parent().get_parent().add_child(attack)
		#print(attack.position)
		#print(position)
		
		FX_play(attacks)
		await get_tree().create_timer(0.1).timeout
		attacks = attacks - 1
		print(attacks)
	
	$Timer.start(rate_of_fire - get_parent().throw_rate)
	
func _on_damageboost_timeout():
	damage = original_damage

func _on_timer_timeout():
	timed_out = false

func enable():
	if !weapon:return
	
	visible=true
	
func disable():
	if !weapon:return
	
	visible=false


func _on_sword_body_entered(body):
	pass # Replace with function body.

func FX_play(name):
	if name==1:
		$star1.play()
	elif name==2:
		$star2.play()
	else:
		$star3.play()
		
