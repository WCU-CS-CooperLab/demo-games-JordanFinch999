extends Area2D
@export var speed = 150
var follow = PathFollow2D.new()
var target = null
var screensize = Vector2.ZERO

func _ready():
	$Sprite2D.frame = randi() % 3
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	path.add_child(follow)
	follow.loop = false
	
func _process(delta):
	follow.progress += speed * delta
	position = follow.global_position
	if follow.progress_ratio >= 1:
		queue_free()
