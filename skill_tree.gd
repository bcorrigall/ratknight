extends Control

signal on_ready
var the_rat
@onready var skill_points = $SkillPoints

# Called when the node enters the scene tree for the first time.
func _ready():
	the_rat = get_tree().get_nodes_in_group("player")
	get_skill_buttons(self)
	emit_signal("on_ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	skill_points.text = str(the_rat[0].skill_points) + " skill points"
	if Input.is_action_pressed("level"):
		if (visible == false):
			visible = true
	if Input.is_action_pressed("escape"):
		if (visible == true):
			visible = false

func get_skill_buttons(node):
	if node is Skill:
		node.add_to_group("skill_buttons")
		
	for button in node.get_children():
		get_skill_buttons(button)
