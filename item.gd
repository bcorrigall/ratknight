extends Node2D
signal healthInc
var type = 0
@export var Item_scene: PackedScene

var friend = true

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	type = randi() % 6

func set_animation(item):
	if(item <= 2):
		$ItemSprite.animation = "Pow"
	if(item > 2):
		$ItemSprite.animation = "Heart"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_animation(type)

func _on_area_entered(area):
	if(area.name.match("theRatArea2D")):
		var the_rat = area.get_parent()
		#print("what's going on")
		if(type >= 3):
			var old_hp=the_rat.health
			the_rat.health += 20
			the_rat.FXPlay("heart")
			if(the_rat.health>20):
				if(the_rat.dying==true):
					the_rat.dying=false
					the_rat.FXPlay("stopdying")
			if(the_rat.maxHealth < the_rat.health):
				the_rat.health = the_rat.maxHealth
			#print("healed")
			var hps=the_rat.health-old_hp
			the_rat.hps_fun(hps)
		if(type <= 2):
			var timer = get_node("../theRat/Weapon/Damageboost")
			the_rat.getboost(7)
			#the_rat.damage_bonus += 25
			#print("damage boost")
			#$BoostTimer.start(5)

		queue_free()

func _on_boost_timer_timeout():
	var the_rat = get_node("../theRat")
	#the_rat.damage_bonus -= 25
	#print("time is out!")
	#the_rat.endeffect(0)
