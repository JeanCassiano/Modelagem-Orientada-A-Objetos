extends CharacterBody2D
class_name Enemy

var _player_ref = null
var _is_attacking: bool = false
var _in_cooldown: bool = false
var _is_dead: bool = false
@export var _health: int = 100
var _is_hurting: bool = false
var SPEED: int = 30
var DAMAGE: int = 20
@onready var healthbar = $HealthBar
@onready var attackarea = $AttackArea
@export_category("Objects")
@export var _texture: Sprite2D = null
@export var _animation: AnimationPlayer = null
@export var _attack_timer: Timer = null
@export var _death_timer: Timer = null
@export var _cooldown_timer: Timer = null
@export var _hurting_timer: Timer = null

func _ready() -> void:
	healthbar.init_health(_health)
	
func _on_detection_area_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("player") and not _is_dead:
		_player_ref = _body


func _on_detection_area_body_exited(_body: Node2D) -> void:
	if _body.is_in_group("player") and not _is_dead:
		velocity = Vector2.ZERO
		_player_ref = null


func _physics_process(delta: float) -> void:
	if _is_dead or _is_hurting:
		return
	_animate()
	
	if _player_ref != null and not _in_cooldown and not _is_dead:
		var _direction: Vector2 = global_position.direction_to(_player_ref.global_position)
		var _distance: float = global_position.distance_to(_player_ref.global_position)
		if _distance < 30 and not _is_attacking and not _in_cooldown and not _player_ref._is_dead:
			_attack_timer.start()
			_cooldown_timer.start()
			_in_cooldown = true
			_is_attacking = true
	
		velocity = _direction * SPEED
		move_and_slide()


func _animate() -> void:
	if _is_attacking and not _is_dead:
		if  _texture.flip_h == false:
			_animation.play("attack")
			return
		else:
			_animation.play("attack_left")
			return
	if velocity != Vector2.ZERO and not _in_cooldown and not _is_dead:
		if  velocity.x > 0:
			_animation.play("walk")
			return
		if  velocity.x < 0:
			_animation.play("walk_left")
			
			return
		
	_animation.play("idle")	
	


func _on_attack_timer_timeout() -> void:
	_is_attacking = false


func _on_cooldown_timeout() -> void:
	_in_cooldown = false


func update_health(value) -> void:
	if not _is_hurting:
		_health -= value
		healthbar.health = _health
		_hurting_timer.start()
		_is_hurting = true
		_animation.play("hurt")
		if _health <= 0:
			_is_dead = true
			_death_timer.start()
			_animation.play("death")


		
func _on_death_timeout() -> void:
	queue_free()


func _on_hurting_timeout() -> void:
	_is_hurting = false


func _on_attack_area_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		_player_ref.update_health(DAMAGE)


func get_health() -> int:
	return _health

func set_health(value: int) -> void:
	_health = value
	healthbar.health = _health
