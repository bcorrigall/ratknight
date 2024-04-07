extends Node2D

@export var speed = 400
@export var maxHealth = 120

var real_speed = speed

@onready var animations = $AnimationPlayer
@onready var weapon = $Weapon
@onready var effect=$Effect

var health = 120
var trap_slowdown = 1
var dying=false



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
signal levelup
var skill_points = 1000
var experience = 0
var experience_to_next = 100
var killcomble=0
signal exp
var skill_buttons

signal gameover
signal playpow
signal endpow
signal kill
signal dash_cool
var damage_bonus = 0
var limited_damage_bonus=0
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
	randomize()
	#screen_size = get_viewport_rect().size
	add_to_group("player")

func start(pos):
	pass
	
func damage_rat(type,damage):
	$RegenTimer.stop()
	if(type=="physic"):
		FXPlay("hit")
	else:
		FXPlay("fire_hit")
	var real_damage = damage - defence_bonus
	#print("real damage:"+str(real_damage))
	if (real_damage > 0):
		health -= damage
		if(health < 0):
			death()
	
	if(health<20):
		dying=true
		FXPlay("dying")
		$RegenTimer.start(5)

func on_skill_up(skill_name):
	#print("Leveling up skill: ", skill_name)
	match skill_name:
		"Damage": damage_bonus += 5
		"Defence": defence_bonus += 5
		"Health": maxHealth += 20
		"Speed": speed += 100
		"Dash Speed": dash_speed += 200
		"Regenerate": regenerate_bonus += 5
		"Dash Attack": dash_attack = true
		"Dash Cooldown": dash_cooldown -= 2
		"Damage 2": damage_bonus += 5
		"Health 2": maxHealth += 20
		"Extra Throwing Star": extra_attacks += 1
		"Extra Throwing Star 2": extra_attacks += 1
		"Increase Throw Rate": throw_rate += 0.2
		"Item Drops": item_drop += 20
		"Enemy Slowdown": enemy_speed += 25

func attack_animation(direction, cooldown):
	attack_direction = rad_to_deg(direction.angle())
	attacking = true
	real_speed = real_speed/2
	$AttackTimeout.start(attack_cooldown)

func dash():
	$theRatArea2D/dashArea.disabled=false
	if (!in_dash and !dash_timed_out and !knocked_back):
		FXPlay("dash_fx")
		in_dash = true
		$Dash.start(dash_time)
		real_speed = dash_speed
		dash_timed_out = true
		$DashTimeout.start(dash_cooldown)
		dash_cool.emit()
		
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
	#position = position.clamp(Vector2.ZERO, screen_size)
	position = position.clamp(Vector2.ZERO, $followCamera.worldSizeInPixels)

	if(health <- 0):
		death()

func attack_light():
	if(!attacking):
		FXPlay("Slash_light")
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
		FXPlay("Slash_spin")
		attacking = true
		$AttackTimeout.start(attack_cooldown)
		animations.play("attackSpin")
		attack_direction = 90
		await animations.animation_finished
		weapon.disable()

func death():
	gameover.emit()
	var simultaneous_scene = load("res://main_menu.tscn").instantiate()
	get_node("/root/Main").queue_free()
	get_tree().root.add_child(simultaneous_scene)
	simultaneous_scene.game_over()

func _on_the_rat_area_2d_area_entered(area):
	if (area.get_name().begins_with("HurtBox") and invincible == false and in_dash == false):
		var enemy = area.get_parent()
		damage_rat("physic",enemy.damage)
		
		var direction = (enemy.position - position).normalized() * 100
		knockback_direction = -direction.normalized() 
		$KnockbackTimer.start(0.2)
		$Invinciblilty.start(invincibility_time)
		knocked_back = true
		invincible = true
	elif (area.get_name().begins_with("WizardBall")):
		var enemy = area
		damage_rat("fire",enemy.damage)
		var direction = (enemy.position - position).normalized() * 100
		knockback_direction = -direction.normalized() 
		$KnockbackTimer.start(0.2)
		$Invinciblilty.start(invincibility_time)
		knocked_back = true
		invincible = true
		print('hit')
		
func _on_area_2d_body_entered(body):
	#print(body)

		
	if (body.get_name().begins_with("Enemy") and in_dash and dash_attack):
		body.get_damage("dash")
		body.health -= 20+damage_bonus
	elif(body.get_name().begins_with("@CharacterBody2D") and in_dash and dash_attack):
		body.get_damage("dash")
		body.health -= 20+damage_bonus


	elif (body.get_name().begins_with("Trap") and !in_dash):
		damage_rat("fire",body.damage)

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
	exp.emit()
	if (experience >= experience_to_next):
		level_up()
func earn_kill():
	killcomble+=1
	kill.emit()

func level_up():
	FXPlay("levelup_fx")
	while(experience >= experience_to_next):
		skill_points += level
		level += 1
		experience -= experience_to_next
		experience_to_next = calculate_experience()
		#print("now level " + str(level))
		exp.emit()
		levelup.emit()

func calculate_experience():
	return experience_to_next + (level * 100)
	
func playeffect(num):
	if num==0:
		effect.play("powerup")
		
func endeffect():
	effect.play("RESET")

func getboost(time):
	if $boost.get_time_left()!=0: #the timer is working
		#print("timer is working")
		$boost.start(time) #reset timer
		damage_bonus-=limited_damage_bonus
		limited_damage_bonus+=25
	else:
		$boost.start(time)
		limited_damage_bonus+=25	
		playeffect(0)
	FXPlay("PowerUp_fx")
	playpow.emit()
	damage_bonus+=limited_damage_bonus


	
func endboost():
	damage_bonus-=limited_damage_bonus #delete all power
	limited_damage_bonus=0
	endpow.emit()
	endeffect()

func _on_dash_timeout():
	in_dash = false
	$playerSprites.position.x = 0
	real_speed = speed
	$theRatArea2D/dashArea.disabled=true

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
	if(health < 20):
		health += regenerate_bonus
		current_regen += regenerate_bonus
		if(health>=20):
			FXPlay("stopdying")
	$RegenTimer.start(5)



func _on_boost_timeout():
	endboost()
	#print("end boost")
	#print("damage_bonus: "+str(damage_bonus))
	#print("damage_bonus: "+str(limited_damage_bonus))
	$boost.stop()


func FXPlay(name):
	if name=="dash_fx":
		$SoundEffect/dash_fx.play()
		
	elif name=="levelup_fx":
		if $SoundEffect/levelup_fx.is_playing():
			$SoundEffect/levelup_fx.stop()
			$SoundEffect/levelup_fx.playing()
		$SoundEffect/levelup_fx.play()
	elif name=="PowerUp_fx":
		#if $SoundEffect/PowerUp_fx.is_playing():
			#$SoundEffect/PowerUp_fx.stop()
		$SoundEffect/PowerUp_fx.play()
	elif name=="fire_hit":
		$SoundEffect/fire_hit.play()
	elif name=="heart":
		$SoundEffect/heart.play()
	elif name=="Slash_light":
		$SoundEffect/Slash_light.play()
	elif name=="Slash_spin":
		$SoundEffect/Slash_spin.play()
	elif name=="hit":
		var type= randi() % 2 #3 type of get hit 0,1,2
		if type==0:
			$SoundEffect/hit_fx_1.play()
		elif type==1:
			$SoundEffect/hit_fx_2.play()
		else:
			$SoundEffect/hit_fx_3.play()
	elif name=="dying":
		$SoundEffect/dying_loop.play()
	elif name=="stopdying":
		$SoundEffect/dying_loop.stop()
	else:
		print("FX error: "+str(name))
		pass


