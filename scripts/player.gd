extends CharacterBody2D

const GRAVITY : float = 700.0
const MOVE_SPEED : float = 175.0
const ACCEL : float = 0.3
const JUMP_POWER : float = -350.0
var x_input_control : float = 1.0
var x_input : float = 0.0
var prev_pos = Vector2(0, 0)
var time = 0.0
var jump_has_been_released = false
var footrot = 0.0


func _process(_delta):
	x_input = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = JUMP_POWER
	if Input.is_action_just_released("jump") && !jump_has_been_released && velocity.y < 0:
		jump_has_been_released = true
		velocity.y *= 0.5
	if is_on_floor():
		jump_has_been_released = false


func _physics_process(delta):
	prev_pos = position
	velocity.x = lerp(velocity.x, x_input * MOVE_SPEED, 0.3 * x_input_control)
	velocity.y = clamp(velocity.y + GRAVITY * delta, -10000.0, GRAVITY)
	move_and_slide()
	
	footrot += velocity.x * 0.15 * delta
	if abs(velocity.x) < MOVE_SPEED * 0.1:
		$visuals/foot_right.rotation_degrees = lerp($visuals/foot_right.rotation_degrees, 0.0, 0.2)
		$visuals/foot_left.rotation_degrees = lerp($visuals/foot_left.rotation_degrees, 0.0, 0.2)
	else:
		$visuals/foot_right.rotation_degrees = sin(footrot) * 40
		$visuals/foot_left.rotation_degrees = sin(footrot + PI) * 40
	
	# arms
	var velocity_adder = -velocity.y * 0.2
	$visuals/hand_right.rotation_degrees = 10 + lerp($visuals/hand_right.rotation_degrees, velocity_adder, 0.3)
	$visuals/hand_left.rotation_degrees = -10 + lerp($visuals/hand_left.rotation_degrees, -velocity_adder, 0.3)
	
	# trail movement
	var trail = $visuals/trail
	var prev_point : Vector2
	for point_idx in trail.get_point_count():
		if point_idx == 0:
			trail.set_point_position(point_idx, Vector2(0, 0))
			prev_point = Vector2(0, 0)
		else:
			trail.points[point_idx] += (prev_pos - position)
			trail.points[point_idx] = lerp(trail.points[point_idx], prev_point, 0.4) + Vector2(0, sin(float(point_idx) * 0.4 + time * 12) * velocity.x * 0.001)
		prev_point = trail.points[point_idx]
	
	time += delta
