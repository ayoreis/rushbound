class_name Player
extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0

var state: State = Idle.new()

func _init() -> void:
	state.player = self


func _physics_process(delta: float) -> void:
	var new_state := state.handle_input()

	if new_state != null:
		var old_state := state
		old_state.exit()
		new_state.player = old_state.player
		new_state.enter()
		state = new_state

	state.update(delta)


@abstract class State:
	var player: Player

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
		if Input.get_axis("left", "right") != 0:
			return Running.new()

		if Input.is_action_pressed("jump") and player.is_on_floor():
			return Jumping.new()

		return null

	func update(delta: float) -> void:
		player.velocity += player.get_gravity() * delta
		player.move_and_slide()

class Running extends State:
	func exit() -> void:
		player.velocity.x = 0

	func handle_input() -> State:
		if Input.is_action_pressed("jump") and player.is_on_floor():
			return Jumping.new()

		if Input.get_axis("left", "right") == 0:
			return Idle.new()

		return null

	func update(delta: float) -> void:
		var direction := Input.get_axis("left", "right")
		player.velocity.x = SPEED * direction
		player.velocity += player.get_gravity() * delta
		player.move_and_slide()

class Jumping extends State:
	func enter() -> void:
		player.velocity.y = JUMP_VELOCITY

	func exit() -> void:
		player.velocity.x = 0

	func handle_input() -> State:
		if player.velocity.y >= 0:
			if Input.get_axis("left", "right") != 0:
				return Running.new()

			return Idle.new()

		return null

	func update(delta: float) -> void:
		var direction := Input.get_axis("left", "right")
		player.velocity.x = SPEED * direction
		player.velocity += player.get_gravity() * delta
		player.move_and_slide()
