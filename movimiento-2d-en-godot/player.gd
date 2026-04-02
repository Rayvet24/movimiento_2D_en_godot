extends CharacterBody2D

@export var speed = 400
@export var gravity = 980
@export var min_jump_foce = -150
@export var max_jump_foce = -250
@export var jump_aceleration = -400

var jumping = false
#func _ready() -> void:
#	pass

func _physics_process(delta) -> void:
	velocity.x = 0
	#velocity.y = 0
	
	if not is_on_floor(): #gravedad
		velocity.y += gravity * delta 
	else:
		velocity.y = 0
		jumping = false
	
	if is_on_floor():
		$Sprite.frame = 0
	
	if Input.is_action_pressed("move_left") and is_on_floor(): #mover izq
		velocity.x -= speed
		$Sprite.flip_h = true
		$Sprite.frame = 12
		#await get_tree().create_timer(0.2).timeout
		#$Sprite.frame = 13
		#$Sprite.frame = 14
		#$Sprite.frame = 15
	if Input.is_action_pressed("move_right") and is_on_floor(): #mover der
		velocity.x += speed
		$Sprite.flip_h = false
		$Sprite.frame = 12
		#$Sprite.frame = 13
		#$Sprite.frame = 14
		#$Sprite.frame = 15
	
	var jump = false #salto
	if is_on_floor():
		jump = true
	
	if Input.is_action_just_pressed("jump") and jump == true: #salto mínimo
		velocity.y += min_jump_foce
		jumping = true
	
	
	#while jumping == true:
	#	$Sprite.frame = 8
	#	$Sprite.frame = 9
	#	$Sprite.frame = 10
	#	$Sprite.frame = 11
	
	
	if Input.is_action_pressed("jump") and jump == true and jumping == true: #salto hasta el max
		if velocity.y > max_jump_foce:
			velocity.y -= jump_aceleration * delta 
		else:
			jumping = false

	if Input.is_action_just_released("jump"): #deja de subir
		jumping = false

	
	if Input.is_action_pressed("attack") and is_on_floor(): #atacar en el piso
		velocity.y -= 1 #atacar en aire

	
	move_and_slide()
