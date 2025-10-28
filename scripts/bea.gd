class_name Bea
extends CharacterBody2D

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


@abstract class State:
	var bea: Bea

	var direction: Vector2:
		get():
			return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	func enter() -> void:
		pass

	func exit() -> void:
		pass

	func handle_input() -> State:
		return null

	func update(_delta: float) -> void:
		pass


class Idle extends State:
	func enter() -> void:
		bea.animated_sprite_2d.animation = &"idle"

	func handle_input() -> State:
		bea.velocity.x = move_toward(bea.velocity.x, 0, 10)

		if direction.x != 0:
			return Running.new() 

		return null


class Running extends State:
	func enter() -> void:
		bea.animated_sprite_2d.animation = &"running"

	func handle_input() -> State:
		if direction.x == 0:
			return Idle.new()

		return null

	func update(_delta: float) -> void:
		bea.velocity.x = move_toward(bea.velocity.x, 100 * direction.x, 10)
		bea.animated_sprite_2d.flip_h = direction.x < 0
