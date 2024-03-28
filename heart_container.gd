extends HBoxContainer
@onready var HeartGuiClass = preload("res://heart_gui.tscn")



func _ready():

	pass
	
func _process(delta):
	pass
	
	
	
func setMaxHeart(max:int):
	for i in range(max):
		print(max)
		var heart = HeartGuiClass.instantiate()
		add_child(heart)
		
func updateHearts(currentHealth: int):
	var hearts = get_children()
	for i in range(currentHealth):
		hearts[i].update(true)
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
	
		
'''
add to main.tscn

@onready var heartsContainer = $"."
in ready:
	heartsContainer.setMaxHeart(3)
	heartsContainer.updateHearts(1)
	⬆️ if have player:
			heartsContainer.setMaxHeart(player.maxHealth)
			heartsContainer.updateHearts(player.currentHealth)
			need connect heart and heartcontainer
			

'''
