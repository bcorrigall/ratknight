extends Node
@export var enemy = preload("res://enemy.tscn")
@export var monster_time = 5
@export var starting_monsters = 10
@export var starting_timer = 1
var start_spawn = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("im here")
	$MonsterTimer.start(1)
	
func spawn_monster():
	var enemyt = enemy.instantiate()
	enemyt.position.x = randi_range(31,1057)
	enemyt.position.y = randi_range(93,456)
	#print(enemyt.get_node("CollisionShape2D"))
	#print(get_parent())
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
