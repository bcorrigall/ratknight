extends Node2D

@export var speed = 400
@export var maxHealth = 120

var real_speed = speed

@onready var animations = $AnimationPlayer
@onready var weapon = $Weapon

var health = 120
var trap_slowdown = 1

var knockback_pos= Vector2.ZERO
var can_control = true

var velocity
var invincible = false

var attacking = false

var attack_hold = false
var attack_cooldown = 0.45
var attack_direction

var knockback_direction = Vector2.ZERO
var knocked_back = false

var dash_direction = Vector2.ZERO
var dash_cooldown = 3
var dash_time = 0.5
var in_dash = false
var dash_timed_out = false
var dash_speed = 800
var dash_attack = false

var invincibility_time = 0.15

var screen_size

var level = 1
var skill_points = 0
var experience = 0
var experience_to_next = 100
var skill_buttons

var damage_bonus = 0
var defence_bonus = 0
var regenerate_bonus = 0
var regen_cap = 20
var current_regen = 0
var extra_attacks = 0
var throw_rate = 0
var item_drop = 0
var enemy_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$RegenTimer.start(0.5)
	add_to_group("player")

func start(pos):
	pass
	
func damage_rat(damage):
	var real_damage = damage - defence_bonus
	if (real_damage > 0):
		health -= damage

func on_skill_up(skill_name):
	print("Leveling up skill: ", skill_name)
	match skill_name:
		"Damage": damage_bonus += 5
		"Defence": defence_bonus += 5
		"Health": maxHealth += 20
		"Speed": speed += 100
		"Dash Speed": dash_speed += 200
		"Regenerate": regenerate_bonus += 0.5
		"Dash Attack": dash_attack = true
		"Dash Cooldown": dash_cooldown -= 2
		"Damage 2": damage_bonus += 5
		"Health 2": maxHealth += 20
		"Extra Throwing Star": extra_attacks += 1
		"Extra Throwing Star 2": extra_attacks += 1
		"Increase Throw Rate": throw_rate += 0.2
		"Item Drop": item_drop += 1
		"Enemy Slowdown": enemy_speed += 25

func attack_animation(direction, cooldown):
	attack_direction = rad_to_deg(direction.angle())
	attacking = true
	real_speed = real_speed/2
	$AttackTimeout.start(attack_cooldown)

func dash():
	if (!in_dash and !dash_timed_out and !knocked_back):
		in_dash = true
		$Dash.start(dash_time)
		real_speed = dash_speed
		dash_timed_out = true
		$DashTimeout.start(dash_cooldown)
		
		if (dash_direction.y < 0):
			$playerSprites.animation = "dash_back"
		elif (dash_direction.x < 0):
			$playerSprites.flip_h = true
			$playerSprites.animation = "dash_side"
		elif (dash_direction.x > 0):
			$playerSprites.flip_h = false
			$playerSprites.animation = "dash_side"
		else:
			$playerSprites.animation = "dash_front"


func _process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
	if (attacking==false):
		weapon.disable()

	if(in_dash):
		velocity = dash_direction
	elif(knocked_back):
		velocity = knockback_direction
	elif(attacking):
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

		if (attack_direction > -45 and attack_direction <= 45):
			$playerSprites.animation = "attack_side"
			$playerSprites.flip_h = false
		elif attack_direction > 45 and attack_direction <= 135:
			$playerSprites.animation = "attack_front"
		elif attack_direction > 135 or attack_direction <= -135:
			$playerSprites.animation = "attack_side"
			$playerSprites.flip_h = true
		else:
			$playerSprites.animation = "attack_back"
		$playerSprites.play()
	else:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1


		if (velocity.y < 0):
			$playerSprites.animation = "move_back"
		elif (velocity.x < 0):
			$playerSprites.flip_h = true
			$playerSprites.animation = "move_side"
		elif (velocity.x > 0):
			$playerSprites.flip_h = false
			$playerSprites.animation = "move_side"
		elif(velocity.y > 0):
			$playerSprites.animation = "move_front"
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * real_speed
		$playerSprites.play()
	elif(!attacking):
		if($playerSprites.animation == "move_side"):
			$playerSprites.animation = "idle_side"
		elif($playerSprites.animation == "move_back"):
			$playerSprites.animation = "idle_back"
		elif($playerSprites.animation == "move_front"):
			$playerSprites.animation = "idle_front"
		$playerSprites.frame = 0

	if(Input.is_action_pressed("dash") and velocity.length() > 0):
		dash_direction = velocity
		dash()
	
	if(knocked_back):
		knockback_direction = velocity
		if (knockback_direction.y < 0):
			$playerSprites.animation = "knocked_front"
		elif (knockback_direction.x < 0):
			$playerSprites.flip_h = false
			$playerSprites.animation = "knocked_side"
		elif (knockback_direction.x > 0):
			$playerSprites.flip_h = true
			$playerSprites.animation = "knocked_side"
		else:
			$playerSprites.animation = "knocked_back"

	if Input.is_action_pressed("attack_light"):
		weapon.enable()
		attack_light()

	if Input.is_action_pressed("attack_spin"):
		weapon.enable()
		attack_spin()

	if(in_dash):
		real_speed = dash_speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if(health <- 0):
		death()

func attack_light():
	if(!attacking):
		var mouse_direction = (get_global_mouse_position() - global_position).normalized()
		var angle = atan2(mouse_direction.y, mouse_direction.x)
		attacking = true
		$AttackTimeout.start(attack_cooldown)
		if (angle < -PI / 4 and angle >= -3 * PI / 4): #back
			animations.play("attackBack")
			attack_direction = -90
		elif(angle < PI / 4 and angle >= -PI / 4): #left
			animations.play("attackRight")
			attack_direction = 0
		elif(angle >= PI / 4 and angle < 3 * PI / 4):#right
			animations.play("attackDown")
			attack_direction = 90
		else:
			animations.play("attackLeft")
			attack_direction = 180
		await animations.animation_finished
		weapon.disable()
		
func attack_spin():
	if(!attacking):
		attacking = true
		$AttackTimeout.start(attack_cooldown)
		animations.play("attackSpin")
		attack_direction = 90
		await animations.animation_finished
		weapon.disable()

func death():
	var simultaneous_scene = load("res://main_menu.tscn").instantiate()
	get_node("/root/Main").queue_free()
	get_tree().root.add_child(simultaneous_scene)

func _on_the_rat_area_2d_area_entered(area):
	if (area.get_name().begins_with("HurtBox") and invincible == false and in_dash == false):
		var enemy = area.get_parent()
		damage_rat(enemy.damage)
		
		var direction = (enemy.position - position).normalized() * 100
		knockback_direction = -direction.normalized() 
		$KnockbackTimer.start(0.2)
		$Invinciblilty.start(invincibility_time)
		knocked_back = true
		invincible = true

func _on_area_2d_body_entered(body):
	print(body)

		
	if (body.get_name().begins_with("Enemy") and in_dash and dash_attack):
		body.get_damage()
		body.health -= 20

	elif (body.get_name().begins_with("Trap") and !in_dash):
		damage_rat(body.damage)

		var direction = (body.position - position).normalized() * 100
		knockback_direction = -direction.normalized() 
		$KnockbackTimer.start(0.2)
		$TrapTimer.start(trap_slowdown)
		$Invinciblilty.start(invincibility_time)
		real_speed = real_speed/2
		knocked_back = true
		invincible = true

func earn_experience(bonus):
	experience += bonus
	if (experience >= experience_to_next):
		level_up()

func level_up():
	while(experience >= experience_to_next):
		skill_points += level
		level += 1
		experience -= experience_to_next
		experience_to_next = calculate_experience()
		print("now level " + str(level))

func calculate_experience():
	return experience_to_next + (level * 100)

func _on_dash_timeout():
	in_dash = false
	$playerSprites.position.x = 0
	real_speed = speed

func _on_invinciblilty_timeout():
	invincible = false

func _on_dash_timeout_timeout():
	dash_timed_out = false

func _on_attack_timeout_timeout():
	attacking = false
	real_speed = speed

func _on_trap_timer_timeout():
	real_speed = speed

func _on_knockback_timer_timeout():
	knocked_back = false

func _on_regen_timer_timeout():
	if(health <= maxHealth and current_regen <= regen_cap):
		health += regenerate_bonus
		current_regen += regenerate_bonus
	$RegenTimer.start(0.5)

