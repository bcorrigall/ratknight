extends Camera2D

@export var tilemap: TileMap
var worldSizeInPixels
# Called when the node enters the scene tree for the first time.
func _ready():
	print(tilemap)
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.rendering_quadrant_size;
	worldSizeInPixels =mapRect.size *tileSize*5
	print(worldSizeInPixels)
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
