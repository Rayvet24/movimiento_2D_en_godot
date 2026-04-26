extends CharacterBody2D

@export var speed = 325 #para mover por x
@export var gravity = 980
@export var jump_force = 100 #para mover por y
@export var jump_time: float = 0.0 #para cortar el salto con un temporizador

var can_jump: bool #si puede saltar
var attacking: bool #si está atacando
var hook_is_active: bool #si el gancho esta activo

# control + k comentar varias lineas

func _on_hurtbox_area_entered(area: Area2D) -> void: #si hurtbox toca el power up
	if area.is_in_group("PowerUps"):
		hook_is_active = true
		area.queue_free() # elimina el nodo del árbol de nodos


func _on_hitbox_area_entered(area: Area2D) -> void: #si hitbox toca un hitable object como lamp, puede saltar
	if area.is_in_group("HitableObjects"):
		can_jump = true
		jump_time = 0.0

func check_overlapping_areas(): #como la colisión se puede activar una vez dentro del area, la señal no funciona, para es caso tenemos este
	var overlapping = $Hitbox.get_overlapping_areas()
	for area in overlapping:
		if area.is_in_group("HitableObjects"):
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
	#=====================================
	#si esta en una plataforma is on floor por lo que can jump es true
	#pero al caer y hasta no tocar de nuevo el suelo sigue siedo true
	#por lo que puede saltar en el aire
	#=====================================
	
	#=====================================
	#if Input.is_action_pressed("down") and Input.is_action_pressed("jump") and is_on_floor():
		#set_collision_mask_value(2, false)
		#if falling_time < 0.05:
			#set_collision_mask_value(2, true)
	#buscar manera de que al cambiar de mask
	#volverla a activar asi se puede apoyar en la otra plataforma
	#=====================================
	
	
	if Input.is_action_pressed("jump") and can_jump == true and !Input.is_action_pressed("down"): #salto
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
		if is_on_floor(): #si esta en el piso hace anim de ataque en el piso
			$AnimatedSprite2D.play("attack_grounded")
		else:
			if !is_on_wall(): #para que no ataque mientras esta colgado
				$AnimatedSprite2D.play("attack_air") #sino la anima de ataque en el aire
	
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
		if is_on_wall() and hook_is_active:
			$AnimatedSprite2D.play("wall_hang")
		else: #si no esta en piso y baja anim de cayendo
			$AnimatedSprite2D.play("jump_end")
	
	#$Hitbox/AttackCollision.disabled = true
	#$ se pone ruta en este caso el nodo y su hijo el cual queremos el metodo
	
	if $AnimatedSprite2D.animation == "attack_grounded" or $AnimatedSprite2D.animation == "attack_air":
		$Hitbox/AttackCollision.disabled = false #activa colision mientra las anim de ataque se reproduzcan
		check_overlapping_areas() #tambien chekea si hay overlapping para evitar bugs
	else: $Hitbox/AttackCollision.disabled = true
	
	
	if hook_is_active:
		if is_on_wall() and !is_on_floor():
			velocity.y = 0  #se mantiene en la pared
			can_jump = true #para que pueda saltar otra vez
			jump_time = 0.0
	
	move_and_slide()
