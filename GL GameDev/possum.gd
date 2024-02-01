extends CharacterBody2D
var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var player_dir
var face = 1
var attack
var possumHP
var dead
var canLunge
var lap

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../Player1/Player")
	get_node("AnimatedSprite2D").play("Move")
	attack = false
	possumHP = 100
	dead = false
	lap = 1
	face = 1
	canLunge = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if possumHP <= 0:
		death()
	player_dir = player.position.x - self.position.x
	if player_dir > 0:
		face = 1
	if player_dir < 0:
		face = -1
	if face == -1:
		get_node("AnimatedSprite2D").flip_h = false
	else:
		get_node("AnimatedSprite2D").flip_h = true
		
	if attack == true:
		attackMode()
	else:
		velocity.x = 0
		
	if $"../../Player1/Player".global_position.x >= 832 and $"../../Player1/Player".global_position.x < 1984 and $"../../Player1/Player".global_position.y < 0:
		if possumHP > 0:
			if Game.dialogueing != true:
				attack = true
	if Game.dialogueing == true:
		attack = false
	
	move_and_slide()


	
	
func death():
	if dead == false:
		dead = true
		attack = false
		get_node("AnimatedSprite2D").play("Death")
		self.set_collision_layer_value(2, false)
		self.set_collision_layer_value(4, true)
		self.set_collision_mask_value(1, false)
		get_node("HitBox/CollisionShape2D").disabled = true
		get_node("HurtBox/CollisionShape2D").disabled = true
		await get_node("AnimatedSprite2D").animation_finished
		self.visible = false


func _on_hurt_box_area_entered(area):
	if area.name == "Stomp":
		possumHP -= 20
		get_node("../../Player1/Player").knockback()

func attackMode():
	if canLunge == true:
		lunge()
		canLunge = false
		$breakTime.start()
	else:
		$AnimatedSprite2D.play("Move")
		
func _on_break_time_timeout():
	canLunge = true

func lunge():
	velocity.x = 500 * face
	$AnimatedSprite2D.play("Lunge")
	$lungeTime.start()
	
func _on_lunge_time_timeout():
	velocity.x = 0

