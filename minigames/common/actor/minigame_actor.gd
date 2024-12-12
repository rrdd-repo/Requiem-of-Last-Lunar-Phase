class_name MinigameActor
extends CharacterBody2D

# Health variables
@export var _max_health: int = 5
var _health: int

# Movement variables
@export var _speed: float = 100

# Shooting variables
var _can_shoot = true
@export var _default_bullet_scene: PackedScene
@export var _current_bullet_scene: PackedScene

func _ready() -> void:
	if _default_bullet_scene:
		_current_bullet_scene = _default_bullet_scene
		
	
	_health = _max_health

func _physics_process(delta: float) -> void:
	move_actor(delta)
	move_and_slide()

func move_actor(delta: float) -> void:
	pass

# Handle shooting for any actor
func shoot(delta: float) -> void:
	if _can_shoot and _current_bullet_scene:
		_can_shoot = false
		var new_bullet_instance = _current_bullet_scene.instantiate()
		var bullet_count = new_bullet_instance._bullet_data._bullet_count
		var spread_angle = new_bullet_instance._bullet_data._spread_angle
		
		for i in range(bullet_count):
			var new_bullet = _current_bullet_scene.instantiate()
			var angle_offset = deg_to_rad(spread_angle * (i - (bullet_count - 1) / 2.0))
			new_bullet.position = global_position
			new_bullet.global_rotation = global_rotation + angle_offset
			
			get_parent().call_deferred("add_child", new_bullet)
			
		await get_tree().create_timer(1 / new_bullet_instance._bullet_data._fire_rate).timeout
		_can_shoot = true

func take_damage(damage: int) -> void:
	_health -= damage
	_health = clamp(_health, 0, _max_health)
	
	if _health == 0:
		queue_free()
