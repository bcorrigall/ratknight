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
		print("hello")
		var new = area.get_parent().get_parent().maxHealth+10
		print(area.get_parent().get_parent().maxHealth)
		area.get_parent().get_parent().maxHealth = new
		print(area.get_parent().get_parent().maxHealth)
		get_node("Hud").updateHearts(new)
