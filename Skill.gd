extends TextureButton
class_name Skill

signal add_skill(skill_name)
var the_rat


@onready var panel = $Panel
@onready var line = $Line2D
@onready var text = $Text
@export var skill_name = ""
@export var skill_cost = 1
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	the_rat = get_tree().get_nodes_in_group("player")
	if get_parent() is Skill:
		line.add_point(global_position + size/2)
		line.add_point(get_parent().global_position+size/2)
	text.text = skill_name

func _process(delta):
	pass

func _on_pressed():
	if (!active and the_rat[0].skill_points >= skill_cost):
		emit_signal("add_skill", skill_name)
		the_rat[0].skill_points -= skill_cost

		active = true
		panel.show_behind_parent = true
		line.default_color = Color(1, 0.45, 0.4)

		var dependents = get_children()
		for dependent in dependents:
			if (dependent is Skill and active):
				dependent.disabled = false
