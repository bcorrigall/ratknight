extends Node
@export var enemy = preload("res://enemy.tscn")
@export var wizard = preload("res://enemy_wizard.tscn")
@export var monster_time = 10
@export var starting_monsters = 3
@export var starting_timer = 1
var start_spawn = false

func _ready():
	#print("im here")
	$MonsterTimer.start(1)

func spawn_monster():
	var choose = randi_range(1,3)
	var enemyt
	if(choose <= 2):
		enemyt = enemy.instantiate()
	else:
		enemyt = wizard.instantiate()

	enemyt.position.x = randi_range(31,5000)
	enemyt.position.y = randi_range(93,2200)
	#print(enemyt.get_node("CollisionShape2D"))
	#print(get_parent())
	get_parent().add_child(enemyt)

func _on_monster_time_timeout():
	var enemynumber=get_tree().get_nodes_in_group("Ant").size()
	enemynumber+=get_tree().get_nodes_in_group("Wizard").size()
	if(enemynumber==30):
		#print("enemy is 30")
		return
	#print("Node right now:" +str(enemynumber))
	if(start_spawn == false):
		for i in range(starting_monsters):
			spawn_monster()
		start_spawn = true
	else:
		$MonsterTimer.start(monster_time)
		if(monster_time >= 0.6):
			monster_time *= 0.9
		spawn_monster()
