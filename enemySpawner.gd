extends Node
@export var enemy = preload("res://enemy.tscn")




# Called when the node enters the scene tree for the first time.
func _ready():
	print("im here")
	$monsterTime.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_monster_time_timeout():
	
	var enemyt = enemy.instantiate()
	enemyt.position.x = randi_range(31,1057)
	enemyt.position.y = randi_range(93,456)
	get_parent().add_child(enemyt)
	
