extends CharacterBody2D

@export var speed = 20
@export var gravity = 980
@export var min_jump_force = -100
@export var max_jump_force = -500
@export var jump_aceleration = -250

var jumping: bool

#func _ready() -> void:
#	pass

# control + k comentar varias lineas

func _physics_process(delta) -> void:
	
	if not is_on_floor(): #si no esta en el piso se activa gravedad
		velocity.y += gravity * delta 
	else:
		velocity.y = 0
		jumping = false
	
	
	if is_on_floor() and velocity.x == 0:
		$AnimatedSprite2D.play("idle") #si no se mueve "idle"
	elif is_on_floor() and velocity.x < 0 or velocity.x > 0 :
		$AnimatedSprite2D.play("walk") #si se mueve y esta en el piso "walk"
	
	if is_on_floor() and !Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
		velocity.x = 0 #si no se toca "a" o "d" no avanza
	elif is_on_floor() and Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left"):
		velocity.x = 0 #si se toca "a" y "d" a la vez no avanza
	elif Input.is_action_pressed("move_left") and is_on_floor():
		velocity.x -= speed #mover izquierda
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("move_right") and is_on_floor():
		velocity.x += speed #mover derecha
		$AnimatedSprite2D.flip_h = false
	
	
	var jump = false #salto
	if is_on_floor():
		jump = true
	
	if Input.is_action_just_pressed("jump") and jump == true: #salto mínimo
		velocity.y += min_jump_force
		jumping = true
	
	#while jumping == true:
	
	if Input.is_action_pressed("jump") and jump == true and jumping == true: #salto hasta el max
		if velocity.y < max_jump_force:
			velocity.y -= jump_aceleration * delta 
		else:
			jumping = false

	if Input.is_action_just_released("jump"): #deja de subir
		jumping = false

	
	#if Input.is_action_pressed("attack") and is_on_floor(): #atacar en el piso
	#	velocity.y -= 1 #atacar en aire

	
	move_and_slide()
