extends Node2D


@export var max_health = 3
@onready var health = max_health

@onready var animator = $AnimationPlayer


func apply_damage(damage):
	health -= damage
	if health < 1:
		animator.play("explode")
	elif health > 0:
		animator.play("hit")




func _on_hurt_area_2d_damage_taken(damage):
	apply_damage(damage)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
			queue_free()
