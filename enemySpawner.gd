extends Node
@export var enemy = preload("res://enemy.tscn")
@export var enemy_wizard = preload("res://enemy_wizard.tscn")
@export var monster_time = 5
@export var starting_monsters = 10
@export var starting_timer = 1
var start_spawn = false
var the_rat

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("im here")
	$MonsterTimer.start(1)

func spawn_monster():
	var random_number = randf()
	var enemyt
	if (random_number <= 0.8):
		enemyt = enemy.instantiate()
	else:
		enemyt = enemy_wizard.instantiate()

	the_rat = get_tree().get_nodes_in_group("player")
	enemyt.position = the_rat[0].global_position
	enemyt.position.x += randi_range(-1057,1057)
	enemyt.position.y += randi_range(-456,456)
	get_parent().add_child(enemyt)

func _on_monster_time_timeout():
	if(start_spawn == false):
		for i in range(starting_monsters):
			spawn_monster()
		start_spawn = true	
	else:
		$MonsterTimer.start(monster_time)
		if(monster_time >= 2.4):
			monster_time *= 0.9
		spawn_monster()
