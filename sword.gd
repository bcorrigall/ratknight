extends Area2D

@onready var shape =$SwordsShape
var friend =true
var the_rat

var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("sword")
	pass

func _on_area_entered(area):
	the_rat = get_tree().get_nodes_in_group("player")
	if(area.get_name().begins_with("HurtBox") and get_parent().visible):
		#print(area.get_parent().health)

		area.get_parent().health = area.get_parent().health - (damage + the_rat[0].damage_bonus)
		#print(area.get_parent().health)
		
