extends Area2D

@onready var shape =$CollisionShape2D
var the_rat

var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	print("sword")

func _on_body_entered(body):
	the_rat = get_tree().get_nodes_in_group("player")
	if(body.get_name().begins_with("Enemy")):
		print(body.health)
		body.health = body.health - (damage + the_rat[0].damage_bonus)
		print(body.health)
