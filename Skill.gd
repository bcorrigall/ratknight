extends TextureButton
class_name Skill

signal add_skill(skill_name)

@onready var panel = $Panel
@onready var line = $Line2D
@onready var text = $Text
@export var skill_name = ""
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() is Skill:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position+size/2)
	text.text = skill_name

func _on_pressed():
	if (!active):
		emit_signal("add_skill", skill_name)

	active = true
	panel.show_behind_parent = true
	line.default_color = Color(1, 0.45, 0.4)

	var dependents = get_children()
	for dependent in dependents:
		if (dependent is Skill and active):
			dependent.disabled = false
