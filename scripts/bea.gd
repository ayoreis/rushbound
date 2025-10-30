class_name Bea
extends CharacterBody2D

@export var current_room: Room

var state: State = Idle.new()

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	state.bea = self


func _physics_process(delta: float) -> void:
	var new_state := state.handle_input()

	if new_state != null:
		var old_state := state
		old_state.exit()
		new_state.bea = self
		new_state.enter()
		state = new_state

	state.update(delta)
	move_and_slide()


func _on_room_body_entered(body: Node2D, source: Area2D) -> void:
	if body != self:
		return

	current_room = source


@abstract class State:
	var bea: Bea

	var direction: Vector2:
		get():
			return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	var jumping: bool:
		get():
			return Input.is_action_just_pressed("jump") and bea.is_on_floor()

	func enter() -> void:
		pass

	func exit() -> void:
		pass

	func handle_input() -> State:
		return null

	func update(_delta: float) -> void:
		pass


class Idle extends State:
	const DECELERATION = 50

	func enter() -> void:
		bea.animated_sprite_2d.animation = &"idle"

	func handle_input() -> State:
		if not bea.is_on_floor():
			return Falling.new()
		
		if jumping:
			return Jumping.new()

		if direction.x != 0:
			return Running.new()    

		return null

	func update(_delta: float) -> void:
		bea.velocity.x = move_toward(bea.velocity.x, 0, DECELERATION)


class Running extends State:
	const SPEED = 80
	const ACCELERATION = 20

	func enter() -> void:
		bea.animated_sprite_2d.animation = &"running"

	func handle_input() -> State:
		if not bea.is_on_floor():
			return Falling.new()
		
		if jumping:
			return Jumping.new()

		if direction.x == 0:
			return Idle.new()

		return null

	func update(_delta: float) -> void:
		bea.velocity.x = move_toward(bea.velocity.x, SPEED * direction.x, ACCELERATION)
		bea.animated_sprite_2d.flip_h = direction.x < 0


class Jumping extends State:
	const HEIGHT = 36
	const FOOT_SPEED = 80
	const DISTANCE_TO_PEAK = 24.0
	const VELOCITY = (-2 * HEIGHT * FOOT_SPEED) / DISTANCE_TO_PEAK
	const GRAVITY = (2 * HEIGHT * (FOOT_SPEED ** 2)) / (DISTANCE_TO_PEAK ** 2)

	func enter() -> void:
		bea.velocity.y = VELOCITY

	func handle_input() -> State:
		if bea.is_on_floor():
			return Idle.new()

		if bea.velocity.y > 0:
			return Falling.new()

		return null

	func update(delta: float) -> void:
		bea.velocity.x = move_toward(bea.velocity.x, direction.x * Running.SPEED, Running.ACCELERATION)
		bea.velocity.y += GRAVITY * delta


class Falling extends State:
	const HEIGHT = 36
	const FOOT_SPEED = 80
	const DISTANCE_TO_PEAK = 20.0
	const VELOCITY = (-2 * HEIGHT * FOOT_SPEED) / DISTANCE_TO_PEAK
	const GRAVITY = (2 * HEIGHT * (FOOT_SPEED ** 2)) / (DISTANCE_TO_PEAK ** 2)

	func handle_input() -> State:
		if not bea.is_on_floor():
			return null

		if jumping:
			return Jumping.new()

		if direction.x != 0:
			return Running.new()

		return Idle.new()

	func update(delta: float) -> void:
		bea.velocity.x = move_toward(bea.velocity.x, direction.x * Running.SPEED, Running.ACCELERATION)
		bea.velocity.y += GRAVITY * delta
