class_name MinigameEnemy
extends MinigameActor

var _health_label: Label
@export var _can_show_label: bool = true
@export var _score: int = 10

var _death_sfx: AudioStreamPlayer2D
var _hit_sfx: AudioStreamPlayer2D
var _shoot_sfx: AudioStreamPlayer2D

func _ready() -> void:
	_death_sfx = $"SFX/DeathSFX"
	_shoot_sfx = $"SFX/ShootSFX"
	_hit_sfx = $"SFX/HitSFX"
	
	if _default_bullet_scene:
		_current_bullet_scene = _default_bullet_scene
	
	_health = _max_health
	if _can_show_label:
		_health_label = %EnemyHealthLabel
		update_health_label()

func _physics_process(delta: float) -> void:
	move_actor(delta)
	if _can_shoot:
		shoot(delta)
		
	move_and_slide()
	
	if position.x < -800 or position.x > get_viewport_rect().size.x + 800:
		queue_free()

func move_actor(delta: float) -> void:
	velocity = (Vector2.LEFT * _speed * delta) * 100

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
			
			_shoot_sfx.play()
			get_parent().call_deferred("add_child", new_bullet)
			
		await get_tree().create_timer(1 / new_bullet_instance._bullet_data._fire_rate).timeout
		_can_shoot = true

func take_damage(damage: int) -> void:
	_health -= damage
	_health = clamp(_health, 0, _max_health)
	
	if _health == 0:
		death()
	else:
		if _can_show_label:
			update_health_label()
			
		_hit_sfx.play()

func update_health_label() -> void:
	_health_label.text = str(_health) + "/" + str(_max_health)

func death() -> void:
	# Disables collision and shooting
	_can_shoot = false
	$Hurtbox.set_collision_mask_value(1, false)
	if _can_show_label:
		_health_label.text = "+ " + str(_score)
		
	$Sprite2D.hide()
	_death_sfx.play()

func _on_area_2d_area_entered(hitbox: Hitbox) -> void:
	take_damage(hitbox.damage)


func _on_death_sfx_finished() -> void:
	MinigameScoreManager.add_score(_score)
	queue_free()
