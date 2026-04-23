extends CharacterBody2D

@export var speed = 325
@export var gravity = 980
@export var jump_time: float = 0.0
@export var jump_force = 100

var can_jump: bool #si puede saltar
var attacking: bool #si está atacando
# control + k comentar varias lineas

func _on_hitbox_area_entered(area: Area2D) -> void: #si hitbox toca un area como lamp, puede saltar
	can_jump = true
	jump_time = 0.0

func check_overlapping_areas():
	var overlapping = $Hitbox.get_overlapping_areas()
	for area in overlapping:
		can_jump = true
		jump_time = 0.0

func _physics_process(delta) -> void:
	
	if !is_on_floor(): #si no esta en el piso se activa gravedad
		velocity.y += gravity * delta 
	
	
	var input_dir = Input.get_axis("move_left", "move_right") 
	#input_dir es una variable, input.get_axis devuelve un numero
	#hace que move_left sea -1, move_right sea 1 y si no se presiona nada es 0
	velocity.x = input_dir * speed
	#al multiplicarlo con velocity hace que la velocidad sea negativa, positiva o 0
	
	
	#funciona en cualquier caso
	if velocity.x < 0: #si vel es negativo girar
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0: #si vel es positivo no girar
		$AnimatedSprite2D.flip_h = false
	
	
	if is_on_floor(): #si esta en el piso puede saltar
		can_jump = true
		jump_time = 0.0
	#si esta en una plataforma is on floor por lo que can jump es true
	#pero al caer y hasta no tocar de nuevo el suelo sigue siedo true
	#por lo que puede saltar en el aire
	
	
	if Input.is_action_pressed("jump") and can_jump == true: #salto
		if jump_time < 0.09: #salta hasta que llega al maximo de tiempo de salto
			velocity.y -= jump_force #aplica fuerza
			jump_time += delta #suma el tiempo hasta llegar a la coindición
		else:
			can_jump = false
			jump_time = 0.0
	
	if Input.is_action_just_released("jump"): #deja de subir
		can_jump = false
	
	
	if Input.is_action_just_pressed("attack"): #atacar
		attacking = true
		if is_on_floor(): #si esta en el piso hace ani de ataque en el piso
			$AnimatedSprite2D.play("attack_grounded")
		else: $AnimatedSprite2D.play("attack_air") #sino la anima de ataque en el aire
	
	if attacking:
		if is_on_floor(): velocity.x = 0
		if !$AnimatedSprite2D.is_playing():
			attacking = false
	else: if is_on_floor(): #si no esta atacando
		if input_dir != 0: #si no esta quieto poner anim de correr
			$AnimatedSprite2D.play("walk")
		else: #si esta quieto idle
			$AnimatedSprite2D.play("idle")
	else:
		if velocity.y < 0: #si no esta en piso y sube pone anim de saltar
			$AnimatedSprite2D.play("jump_start")
		else: #si no esta en piso y baja anim de cayendo
			$AnimatedSprite2D.play("jump_end")
	
	#$Hitbox/AttackCollision.disabled = true
	#$ se pone ruta en este caso el nodo y su hijo el cual queremos el metodo
	
	if $AnimatedSprite2D.animation == "attack_grounded" or $AnimatedSprite2D.animation == "attack_air":
		$Hitbox/AttackCollision.disabled = false
		check_overlapping_areas()
	else: $Hitbox/AttackCollision.disabled = true
	
	move_and_slide()
