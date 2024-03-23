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
		var new_health = area.get_parent().get_parent().health+20
		area.get_parent().get_parent().health = new_health
		if(area.get_parent().get_parent().maxHealth < new_health):
			area.get_parent().get_parent().health = area.get_parent().get_parent().maxHealth
		var hearts = get_node("../HUD/HeartContainer")
		hearts.updateHearts(area.get_parent().get_parent().health)
		print(hearts)
