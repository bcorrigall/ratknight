extends Node2D
signal healthInc
var type = 0
@export var Item_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	type = randi() % 6
	type = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	type = 3
	if(type <= 2):
		$ItemSprite.animation = "Guy"
	if(type >= 3):
		$ItemSprite.animation = "Heart"


func _on_area_entered(area):
	if(area.name.match("theRatArea2D")):
		if(type == 3):
			var the_rat = area.get_parent()
			var new_health = the_rat.health+20
			the_rat.health = new_health
			if(the_rat.maxHealth < new_health):
				the_rat.health = the_rat.maxHealth
			var hearts = get_node("../HUD/HeartContainer")
			hearts.updateHearts(the_rat.health)
			print(hearts)
			
		if(type == 2):
			var the_rat = area.get_parent()
			var weapon = get_node("../theRat/Weapon")
			var timer = get_node("../theRat/Weapon/Damageboost")
			weapon.damage = weapon.damage + 25
			timer.start()
		queue_free()
			

