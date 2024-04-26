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
var footrot : float = 0.0
var dash_dir = Vector2(1, 0)
var can_dash = true
var is_dashing : int = 0
var lingering_dash_time : int = 0
var has_been_on_floor : int = 0
var has_done_jump_input : int = 0
var dash_bounces : int = 0


func _process(_delta):
	x_input = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		has_done_jump_input = 7
	if has_done_jump_input > 0 && has_been_on_floor > 0:
		has_done_jump_input = 0
		velocity.y = JUMP_POWER + dash_bounces * JUMP_POWER * 0.35
		# dash jumping!
		if lingering_dash_time > 0:
			velocity.x = dash_dir.x * MOVE_SPEED * 10
			x_input_control = 0.0
			if dash_dir == Vector2(0, 1):
				dash_bounces += 1
				print(dash_bounces)
			else:
				dash_bounces = 0
		else:
			dash_bounces = 0 
	
	if Input.is_action_just_released("jump") && !jump_has_been_released && velocity.y < 0:
		jump_has_been_released = true
		velocity.y *= 0.5
	
	if is_on_floor():
		has_been_on_floor = 7
		jump_has_been_released = false
		can_dash = true
	
	var input_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if input_dir != Vector2(0, 0):
		dash_dir = input_dir
	
	if Input.is_action_just_pressed("dash") && can_dash && lingering_dash_time <= 0:
		dash()


func _physics_process(delta):
	prev_pos = position
	velocity.x = lerp(velocity.x, x_input * MOVE_SPEED, 0.3 * x_input_control)
	velocity.y = clamp(velocity.y + GRAVITY * delta, -10000.0, GRAVITY)
	if is_dashing > 0:
		velocity = dash_dir.normalized() * MOVE_SPEED * 5 * Vector2(1, 0.5)
		is_dashing -= 1
	
	move_and_slide()
	
	# legs
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
	
	if x_input_control < 1.0:
		x_input_control += 0.05
	
	if lingering_dash_time > 0:
		lingering_dash_time -= 1
	
	if has_been_on_floor > 0:
		has_been_on_floor -= 1
	
	if has_done_jump_input > 0:
		has_done_jump_input -= 1
	
	time += delta


func dash():
	can_dash = false
	is_dashing = 4
	x_input_control = 0.0
	lingering_dash_time = 15
