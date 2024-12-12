class_name Bullet
extends CharacterBody2D

@export var _bullet_data: BulletData

var _speed: float
var _direction: Vector2 = Vector2.RIGHT

func _ready():
	_speed = _bullet_data._initial_speed
	
	_direction = Vector2.RIGHT.rotated(global_rotation)
	
	await get_tree().create_timer(_bullet_data._lifespan).timeout
	await before_lifespan_expired()
	queue_free()

func _physics_process(delta: float) -> void:
	_speed = lerp(_speed, _bullet_data._target_speed, _bullet_data._acceleration * delta)
	velocity = _direction * _speed * delta
		
	var collision := move_and_collide(velocity)
	if collision:
		queue_free()

func before_lifespan_expired() -> void:
	pass
