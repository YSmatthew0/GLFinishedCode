extends CharacterBody2D
var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var player_dir
var face = 1
var attack = false
var frogHP
var dead

func _ready():
	player = get_node("../../Player1/Player")
	get_node("AnimatedSprite2D").play("Idle")
	attack = false
	frogHP = 100
	dead = false
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if frogHP <= 0:
		death()
	player_dir = player.position - self.position
	if attack == true:
		attackMode()
	else:
		velocity.x = 0
	if get_node("../../Player1/Player").global_position.x > 1152 and get_node("../../Player1/Player").global_position.x < 2304:
		if frogHP > 0:
			if Game.dialogueing != true:
				attack = true
	if Game.dialogueing == true:
		attack = false
		get_node("AnimatedSprite2D").play("Idle")
			
		
	move_and_slide()
func attackMode():
	if dead == false:
		var dashing = false
		if player_dir.x < -35:
			face = -1
			get_node("AnimatedSprite2D").flip_h = false
			get_node("AnimatedSprite2D").play("Jump")
		else:
			if player_dir.x > 35:
				face = 1
				get_node("AnimatedSprite2D").flip_h = true
				get_node("AnimatedSprite2D").play("Jump")
			else:
				face = 0
				get_node("AnimatedSprite2D").play("Idle")
				
		if dashing == false:
			if frogHP == 100:
				velocity.x = SPEED * face * 0.5
			else:
				if frogHP >= 60:
					velocity.x = SPEED * face * 0.7
					if is_on_floor():
						velocity.y = SPEED * -3.5
				else: 
						velocity.x = SPEED * face * 0.9
						if is_on_floor():
							velocity.y = SPEED * -4.5
			move_and_slide()
			
		
func _on_hurt_box_area_entered(area):
	if area.name == "Stomp":
		frogHP -= 20
		if frogHP == 60:
			get_node("../../Player1/Player").strongKnockback()
			
		if frogHP == 40:
			get_node("../../Player1/Player").strongKnockback()
			
		
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
		



