extends CharacterBody2D

const GRAVITY = 1000.0
const FLAP_SPEED = -500.0
const MAX_VEL_Y = 600.0
const START_POS = Vector2(200, 300)

var flying = false
var falling = false

func _ready():
	reset()

func reset():
	position = START_POS
	velocity = Vector2.ZERO
	flying = false
	falling = false
	set_rotation(0)
	$AnimatedSprite2D.stop()
	if get_node_or_null("/root/Main/CanvasLayer/StartLabel"):
		get_node("/root/Main/CanvasLayer/StartLabel").show()

func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL_Y:
			velocity.y = MAX_VEL_Y

		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI / 2)
			$AnimatedSprite2D.stop()

		move_and_collide(velocity * delta)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

func _input(event):
	if event.is_action_pressed("flap") and not falling:
		flap()
		handle_ui_on_flap()

func flap():
	velocity.y = FLAP_SPEED
	flying = true

func handle_ui_on_flap():
	if get_node_or_null("/root/Main/CanvasLayer/StartLabel"):
		get_node("/root/Main/CanvasLayer/StartLabel").hide()
