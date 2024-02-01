extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var knockbackPower: int = 5000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $"."
@onready var anim = get_node("AnimationPlayer")
var health
var maxHealth = 100
var enemyDir
var knockingBack

func _ready():
	anim.play("Idle")
	health = maxHealth
	knockingBack = false
	
	
	
func _physics_process(delta):
	# Add the gravity.
	if Game.dialogueing == false:
		getInput()
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	if global_position.y > 640:
		health = 0
	
	if global_position.x >= 1152 and global_position.x <= 2304 and global_position.y >= 0 and $"../../Mobs/Frog".dead == false:
		arena1()
	else:
		$Camera2D.enabled = true
		$"../../FrogArena/FrogArena/Camera2D".enabled = false
	if global_position.x >= 832 and global_position.x <1984 and global_position.y < 0:
		if $"../../Mobs/Possum".possumHP > 0 or $"../../Mobs/eagle".eagleHP > 0:
			arena2()
	else:
		$Camera2D.enabled = true
		$"../../VillageArena/Camera2D".enabled = false
	
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://game_over.tscn")
	
	
			
func getInput():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if knockingBack == false:
		if Game.dialogueing == false:
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				velocity.x = direction * SPEED
				if velocity.y == 0:
					anim.play("Run")
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if velocity.y == 0:
					anim.play("Idle")
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				anim.play("Jump")
			if velocity.y > 0:
				anim.play("Fall")
		else:
			velocity = Vector2(0, 0)
			
	else:
		anim.play("Hurt")
	
	move_and_slide()
	
	
func _on_hurt_box_area_entered(area):
	if area.name == "HitBox":
		if knockingBack == false:
			health -= 20
			knockback()
		
func _on_stomp_area_entered(area):
	if area.name == "HurtBox":
		if knockingBack == false:
			knockback()	
		
	
func knockback():
	knockingBack = true
	if enemyDir == 1:
		velocity = Vector2(-500, -400)
		move_and_slide()
	else:
		velocity = Vector2(500, -400)
		move_and_slide()
	anim.play("Hurt")
	await get_tree().create_timer(0.5).timeout
	knockingBack = false
	
func LwallKnockback():
	knockingBack = true
	velocity = Vector2(350, -500)
	move_and_slide()
	anim.play("Hurt")
	await get_tree().create_timer(0.5).timeout
	knockingBack = false

func RwallKnockback():
	knockingBack = true
	velocity = Vector2(-350, -500)
	move_and_slide()
	anim.play("Hurt")
	await get_tree().create_timer(0.5).timeout
	knockingBack = false
	
func strongKnockback():
	knockingBack = true
	if enemyDir == 1:
		velocity = Vector2(-800, -600)
		move_and_slide()
	else:
		velocity = Vector2(800, -600)
		move_and_slide()
	anim.play("Hurt")
	await get_tree().create_timer(1).timeout
	knockingBack = false

func arena1():
	$Camera2D.enabled = false
	$"../../FrogArena/FrogArena/Camera2D".enabled = true
	if ((get_node("../../Mobs/Frog").global_position).x - (global_position).x) >= 0:
			enemyDir = 1
	else:
			enemyDir = -1

func arena2():
	$Camera2D.enabled = false
	$"../../VillageArena/Camera2D".enabled = true
	if ((get_node("../../Mobs/Possum").global_position).x - (global_position).x) >= 0:
			enemyDir = 1
	else:
			enemyDir = -1
