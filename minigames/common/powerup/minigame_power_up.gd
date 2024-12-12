class_name MinigamePowerUp
extends Area2D

@export var _bullet_scenes: Array[PackedScene]

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	queue_free()
	

func change_bullet(player: MinigameActor):
	if _bullet_scenes.size() > 0:
		var random_bullet_scene = _bullet_scenes[randi() % _bullet_scenes.size()]
		player._current_bullet_scene = random_bullet_scene
		queue_free()
