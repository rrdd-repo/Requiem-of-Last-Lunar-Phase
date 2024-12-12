class_name MinigamePlayer
extends MinigameActor

@export var _multiplier: float = 0.5
var _bullet_spawn_marker: Marker2D

@export var _can_show_label: bool = true
var _health_label: Label

# Honestly an array or a list or some other form would be better but we tight on time lmao
var _death_sfx: AudioStreamPlayer2D
var _hit_sfx: AudioStreamPlayer2D
var _shoot_sfx: AudioStreamPlayer2D
var _powerup_sfx: AudioStreamPlayer2D

func _ready() -> void:
	# SFX
	_death_sfx = $"SFX/DeathSFX"
	_shoot_sfx = $"SFX/ShootSFX"
	_hit_sfx = $"SFX/HitSFX"
	_powerup_sfx = $"SFX/PowerupSFX"
	
	# Bullet spawning
	_current_bullet_scene = _default_bullet_scene
	_bullet_spawn_marker = %PlayerBulletSpawn
	
	# Health properties
	_health = _max_health
	if _can_show_label:
		_health_label = %PlayerHealthLabel
		update_health_label()
		
	#Sprite
	z_index = 1

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _can_shoot:
		shoot(delta)
	move_actor(delta)
	move_and_slide()

func shoot(delta: float) -> void:
	if _can_shoot and _current_bullet_scene:
		_can_shoot = false
		var new_bullet_instance = _current_bullet_scene.instantiate()
		var bullet_count = new_bullet_instance._bullet_data._bullet_count
		var spread_angle = new_bullet_instance._bullet_data._spread_angle

		for i in range(bullet_count):
			var new_bullet = _current_bullet_scene.instantiate()
			var angle_offset = deg_to_rad(spread_angle * (i - (bullet_count - 1) / 2.0))
			
			# Set the bullet's position to the marker's position
			new_bullet.position = _bullet_spawn_marker.global_position  
			new_bullet.global_rotation = global_rotation + angle_offset
			new_bullet.z_index = 0
			
			get_parent().call_deferred("add_child", new_bullet)
			_shoot_sfx.play()
		
		await get_tree().create_timer(1 / new_bullet_instance._bullet_data._fire_rate).timeout
		_can_shoot = true


func move_actor(delta: float) -> void:
	var movement_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	movement_vector = movement_vector.normalized()
	var is_focusing: bool = Input.is_action_pressed("focus")
	var speed_multiplier: float = _multiplier if is_focusing else 1.0
	
	if movement_vector:
		velocity = (movement_vector * (_speed * speed_multiplier) * delta) * 100
	else:
		velocity = movement_vector

func update_health_label() -> void:
	_health_label.text = str(_health) + "/" + str(_max_health)

func take_damage(damage: int) -> void:
	_health -= damage
	_health = clamp(_health, 0, _max_health)
	
	if _health == 0:
		death()
	else:
		if _can_show_label:
			update_health_label()
			
		_hit_sfx.play()
	
func death() -> void:
	# Disable collision and shooting
	$Hurtbox.set_collision_mask_value(2, false)
	$Hurtbox.set_collision_mask_value(3, false)
	_can_shoot = false
	if _can_show_label:
		_health_label.text = "RIP"
		
	$Sprite2D.hide()
	_death_sfx.play()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox = area as Hitbox
		take_damage(hitbox.damage)
	if area is MinigamePowerUp:
		_powerup_sfx.play()
		area.change_bullet(self)


func _on_death_sfx_finished() -> void:
	MinigameScoreManager._score = 0
	get_tree().reload_current_scene()
