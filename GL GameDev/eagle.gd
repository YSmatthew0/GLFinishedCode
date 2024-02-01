extends CharacterBody2D
var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var player_dir
var face = 1
var attack
var eagleHP
var dead
var canLunge

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../Player1/Player")
	get_node("AnimatedSprite2D").play("Fly")
	attack = false
	eagleHP = 100
	dead = false
	face = 1
	canLunge = true
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if eagleHP <= 0:
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
		
	if $"../../Player1/Player".global_position.x > 832 and $"../../Player1/Player".global_position.x < 1984 and $"../../Player1/Player".global_position.y < 0:
		if eagleHP > 0:
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
		eagleHP -= 20
		get_node("../../Player1/Player").knockback()

func attackMode():
	if canLunge == true:
		lunge()
		$AnimatedSprite2D.play("Dive")
		canLunge = false
		$breakTime.start()
	else:
		$AnimatedSprite2D.play("Fly")
	
		
func _on_break_time_timeout():
	canLunge = true

func lunge():
	velocity = Vector2(player.position.x - position.x,player.position.y - position.y)*2
	$AnimatedSprite2D.play("Dive")
	$lungeTime.start()
	move_and_slide()
	
func _on_lunge_time_timeout():
	velocity.y = -250
	move_and_slide()
