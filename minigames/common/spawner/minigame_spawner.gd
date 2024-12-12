class_name MinigameSpawner
extends Node2D

# Spawning variables
@export var min_spawn_interval: float = 1.0
@export var max_spawn_interval: float = 5.0
@export var spawnable_scene: PackedScene

# Map bounds variables
@export var map_bounds_min: Vector2
@export var map_bounds_max: Vector2

var _time_until_next_spawn: float = 0.0

func _ready() -> void:
	randomize_spawn_time()

func _physics_process(delta: float) -> void:
	_time_until_next_spawn -= delta
	
	if _time_until_next_spawn <= 0.0:
		spawn_object()
		randomize_spawn_time()

func spawn_object() -> void:
	if spawnable_scene:
		print("did we even get here")
		var instance = spawnable_scene.instantiate()   
		
		var random_position = Vector2(
			randi_range(int(map_bounds_min.x), int(map_bounds_max.x)),
			randi_range(int(map_bounds_min.y), int(map_bounds_max.y))
		)
		
		instance.position = random_position
		add_child(instance)
		print("Spawned instance " + instance)

func randomize_spawn_time() -> void:
	_time_until_next_spawn = randf_range(min_spawn_interval, max_spawn_interval)
