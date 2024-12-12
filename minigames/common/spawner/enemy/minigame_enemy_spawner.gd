class_name MinigameEnemySpawner
extends MinigameSpawner

@export var possible_bullet_scene: Array[PackedScene]

func spawn_object() -> void:
	var enemy_instance = spawnable_scene.instantiate()
	
	var random_position = Vector2(
			randi_range(int(map_bounds_min.x), int(map_bounds_max.x)),
			randi_range(int(map_bounds_min.y), int(map_bounds_max.y))
		)
		
	enemy_instance.position = random_position
	
	# Assigns a random bullet to the enemy
	var random_bullet_scene = possible_bullet_scene[randi() % possible_bullet_scene.size()]
	enemy_instance._default_bullet_scene = random_bullet_scene
	
	add_child(enemy_instance)
