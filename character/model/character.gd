extends CharacterBody2D

var _state_machine
var _is_attacking: bool = false
var _is_attacking2: bool = false
var _is_attacking3: bool = false
var _is_hurting: bool = false
var _is_dead: bool = false
@export var _health: int = 100
@export var _mana: int = 100
@export var _score: int = 0


@onready var healthbar = $HealthBar
@onready var manabar = $ManaBar
@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _acceleration: float = 0.2
@export var _friction: float = 0.2


@export_category("Objects")
@export var _animation_tree: AnimationTree = null
@export var _attack_timer: Timer = null
@export var _attack2_timer: Timer = null
@export var _attack3_timer: Timer = null
@export var _hurting_timer: Timer = null
@export var _death_timer: Timer = null

func _ready() -> void:
	healthbar.init_health(_health)
	manabar.init_mana(_mana)
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]
	
	  
func _physics_process(delta: float) -> void:
	if  _is_hurting or _is_dead:
		return
	_move()
	_attack()
	_animate()
	move_and_slide()

func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction
		_animation_tree["parameters/attack2/blend_position"] = _direction
		_animation_tree["parameters/attack3/blend_position"] = _direction
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
		
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)
		
	
	velocity = _direction.normalized() * _move_speed


func _attack() -> void:
	if Input.is_action_just_pressed("attack") and not _is_attacking and not _is_attacking3 and not _is_attacking3:
		_attack_timer.start()
		_is_attacking = true
	if Input.is_action_just_pressed("attack2") and not _is_attacking and not _is_attacking3 and not _is_attacking3:
		if _mana >= 20:
			_mana -= 20
			manabar.mana = _mana
			_attack2_timer.start()
			_is_attacking2 = true
	if Input.is_action_just_pressed("attack3") and not _is_attacking and not _is_attacking3 and not _is_attacking3:
		if _mana >= 40:
			_mana -= 40
			manabar.mana = _mana
			_attack3_timer.start()
			_is_attacking3 = true
		
func _animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
		return
	if _is_attacking2:
		_state_machine.travel("attack2")
		return
	if _is_attacking3:
		_state_machine.travel("attack3")
		return
	if velocity.length() > 2:
		_state_machine.travel("walk")
		return
		
	_state_machine.travel("idle")


func _on_attack_timer_timeout() -> void:
	_is_attacking = false


func _on_attack_area_body_entered(_body) -> void:
	if _body.is_in_group("enemy"):
		if(_is_attacking):
			_body.update_health(10)
			_mana += 5
			manabar.mana = _mana
			_score += 10
		if(_is_attacking2):
			_body.update_health(randi_range(1, 40))
			_score += 5
		if(_is_attacking3):
			_body.update_health(randi_range(1, 60))
			_score += 2


func _on_attack_2_timer_timeout() -> void:
	_is_attacking2 = false


func _on_attack_3_timer_timeout() -> void:
	_is_attacking3 = false


func update_health(value) -> void:
	if not _is_hurting:
		_health -= value
		healthbar.health = _health
		if _health <= 0:
			_is_dead = true
			_death_timer.start()
			_state_machine.travel("death")
			return
		
		
		_hurting_timer.start()
		_state_machine.travel("hurting")
		_is_hurting = true


func _on_hurting_timeout() -> void:
	_is_hurting = false


func _on_death_timeout() -> void:
	_is_dead = false
	get_tree().reload_current_scene()
	
func get_health() -> int:
	return _health

func set_health(value: int) -> void:
	_health = value
	healthbar.health = _health
	
func get_score():
	return _score


func set_score(value: int) -> void:
	_score = value
