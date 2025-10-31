class_name Player
extends CharacterBody2D

var state: State = Idle.new()
var current_room: Room

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	state.player = self


func _physics_process(delta: float) -> void:
	var new_state := state.handle_input()

	if new_state != null:
		var old_state := state
		old_state.exit()
		new_state.player = self
		new_state.enter()
		state = new_state

	state.update(delta)
	move_and_slide()


func _on_room_body_entered(body: Node2D, source: Room) -> void:
	if body != self:
		return

	current_room = source


@abstract class State:
	var player: Player

	var direction: Vector2:
		get():
			return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	var jumping: bool:
		get():
			return Input.is_action_just_pressed("jump") and player.is_on_floor()

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
		player.animated_sprite_2d.animation = &"idle"

	func handle_input() -> State:
		if not player.is_on_floor():
			return Falling.new()
		
		if jumping:
			return Jumping.new()

		if direction.x != 0:
			return Running.new()    

		return null

	func update(_delta: float) -> void:
		player.velocity.x = move_toward(player.velocity.x, 0, DECELERATION)


class Running extends State:
	const SPEED = 80
	const ACCELERATION = 20

	func enter() -> void:
		player.animated_sprite_2d.animation = &"running"

	func handle_input() -> State:
		if not player.is_on_floor():
			return Falling.new()
		
		if jumping:
			return Jumping.new()

		if direction.x == 0:
			return Idle.new()

		return null

	func update(_delta: float) -> void:
		player.velocity.x = move_toward(player.velocity.x, SPEED * direction.x, ACCELERATION)
		player.animated_sprite_2d.flip_h = direction.x < 0


class Jumping extends State:
	const HEIGHT = 36
	const FOOT_SPEED = 80
	const DISTANCE_TO_PEAK = 24.0
	const VELOCITY = (-2 * HEIGHT * FOOT_SPEED) / DISTANCE_TO_PEAK
	const GRAVITY = (2 * HEIGHT * (FOOT_SPEED ** 2)) / (DISTANCE_TO_PEAK ** 2)

	func enter() -> void:
		player.velocity.y = VELOCITY

	func handle_input() -> State:
		if player.is_on_floor():
			return Idle.new()

		if player.velocity.y > 0:
			return Falling.new()

		return null

	func update(delta: float) -> void:
		player.velocity.x = move_toward(player.velocity.x, direction.x * Running.SPEED, Running.ACCELERATION)
		player.velocity.y += GRAVITY * delta


class Falling extends State:
	const HEIGHT = 36
	const FOOT_SPEED = 80
	const DISTANCE_TO_PEAK = 20.0
	const VELOCITY = (-2 * HEIGHT * FOOT_SPEED) / DISTANCE_TO_PEAK
	const GRAVITY = (2 * HEIGHT * (FOOT_SPEED ** 2)) / (DISTANCE_TO_PEAK ** 2)

	func handle_input() -> State:
		if not player.is_on_floor():
			return null

		if jumping:
			return Jumping.new()

		if direction.x != 0:
			return Running.new()

		return Idle.new()

	func update(delta: float) -> void:
		player.velocity.x = move_toward(player.velocity.x, direction.x * Running.SPEED, Running.ACCELERATION)
		player.velocity.y += GRAVITY * delta
