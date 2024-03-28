extends Node2D
signal healthInc
var type = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	type = randi() % 6


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(type <= 2):
		$ItemSprite.animation = "Guy"
	if(type >= 3):
		$ItemSprite.animation = "Heart"


func _on_area_entered(area):
	if(area.name.match("theRatArea2D")):
		var the_rat = area.get_parent()
		var new_health = the_rat.health+20
		the_rat.health = new_health
		if(the_rat.maxHealth < new_health):
			the_rat.health = the_rat.maxHealth
		var hearts = get_node("../HUD/HeartContainer")
		hearts.updateHearts(the_rat.health)
		print(hearts)
