class_name MinigamePowerupSpawner
extends MinigameSpawner

func spawn_object() -> void:
	var powerup_instance = spawnable_scene.instantiate()
	
	var random_position = Vector2(
		randi_range(int(map_bounds_min.x), int(map_bounds_max.x)),
		randi_range(int(map_bounds_min.y), int(map_bounds_max.y))
	)
	
	powerup_instance.position = random_position
	add_child(powerup_instance)
