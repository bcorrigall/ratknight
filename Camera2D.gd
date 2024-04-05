extends Camera2D

@export var randomStrength: float =5.0# can change it to edit the shake effect
@export var shakeFade: float =3.0# can change it to edit the shake effect
var shakebool=false
var rng = RandomNumberGenerator.new()
var shake_strength: float =0.0

func apply_shake():
	shake_strength=randomStrength

	
	
func randomOffset() ->Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shakebool==true:
		apply_shake()
		
	if shake_strength>0:
		shake_strength=lerpf(shake_strength,0,shakeFade*delta)
		
		offset=randomOffset()

func shake_change():
	shakebool=true
func shake_false():
	shakebool=false
