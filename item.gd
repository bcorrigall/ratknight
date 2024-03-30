extends Node2D
signal healthInc
var type = 0
@export var Item_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	type = randi() % 6

func set_animation(item):
	if(item <= 2):
		$ItemSprite.animation = "Guy"
	if(item > 2):
		$ItemSprite.animation = "Heart"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_animation(type)

func _on_area_entered(area):
	if(area.name.match("theRatArea2D")):
		var the_rat = area.get_parent()
		print("what's going on")
		if(type >= 3):
			the_rat.health += 20
			if(the_rat.maxHealth < the_rat.health):
				the_rat.health = the_rat.maxHealth
			print("healed")

		if(type <= 2):
			var weapon = get_node("../theRat/Weapon")
			var timer = get_node("../theRat/Weapon/Damageboost")
			weapon.damage += 25
			print("damage boost")
			$BoostTimer.start(5)
			
		queue_free()

func _on_boost_timer_timeout():
	var weapon = get_node("../theRat/Weapon")
	weapon.damage -= 25
