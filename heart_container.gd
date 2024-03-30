extends HBoxContainer
@onready var HeartGuiClass = preload("res://heart_gui.tscn")



func _ready():

	pass
	
func setMaxHeart(max:int):
	max = max / 20
	while(get_children().size() != max):
		print(max)
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

func updateHearts(current_health: int):
	var hearts = get_children()
	var max = hearts.size()
	var fullness = current_health/5

	for i in range(max):
		var current = (i + 1) * 4
		var update_value = max(0, min(4, current - fullness))
		hearts[i].update(update_value)
