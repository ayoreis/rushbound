class_name Player
extends CharacterBody2D

const SPEED = 100.0

var state: State = Idle.new()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


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


@abstract class State:
	var player: Player
	
	var direction: float:
		get():
			return Input.get_axis("move_left", "move_right")

	var jumping: bool:
		get():
			return Input.is_action_just_pressed("jump")

	func enter() -> void:
		pass

	func exit() -> void:
		pass

	func handle_input() -> State:
		return

	func update(_delta: float) -> void:
		pass


class Idle extends State:
	func handle_input() -> State:
		if not player.is_on_floor():
			return Falling.new()

		if jumping:
			return Jumping.new()

		if direction != 0:
			return Running.new()

		return null


class Running extends State:
	const SPEED = 300


	func exit() -> void:
		player.velocity.x = 0

	func handle_input() -> State:
		if not player.is_on_floor():
			return Falling.new()

		if jumping:
			return Jumping.new()

		if direction == 0:
			return Idle.new()

		return null

	func update(_delta: float) -> void:
		player.velocity.x = direction * SPEED


class Jumping extends State:
	const VELOCITY = -400
	const SPEED = 300

	func enter() -> void:
		player.velocity.y = VELOCITY

	func handle_input() -> State:
		if player.velocity.y >= 0:
			return Falling.new()

		return null

	func update(delta: float) -> void:
		player.velocity.x = direction * SPEED
		player.velocity += player.get_gravity() * delta

class Falling extends State:
	const SPEED = 300

	func handle_input() -> State:
		if player.is_on_floor():
			if jumping:
				return Jumping.new()

			if direction == 0:
				return Idle.new()

			return Running.new()

		return null

	func update(delta: float) -> void:
		player.velocity.x = direction * SPEED
		player.velocity += player.get_gravity() * delta
