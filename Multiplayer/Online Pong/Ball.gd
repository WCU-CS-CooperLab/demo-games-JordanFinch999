extends Node2D


@export var speed = 600.0

@onready var body = $CharacterBody2D


func _ready():
	pass

func move():
	body.velocity.x = [-speed, speed][randi()%2]
	body.velocity.y = [-speed, speed][randi()%2]


func reset():
	body.global_position = global_position
	move()


func _physics_process(delta):
	var collision = body.move_and_collide(body.velocity * delta)
	if collision:
		body.velocity = body.velocity.bounce(collision.get_normal())
