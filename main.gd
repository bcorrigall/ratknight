extends Node


@onready var heartsContainer = $"res://heart_container.tscn"
func _ready():
	heartsContainer.setMaxHeart(3)
	heartsContainer.updateHearts(1)
	heartsContainer.setMaxHeart(get_node("theRat").maxHealth / 20)
	heartsContainer.updateHearts(get_node("theRat").currentHealth)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
