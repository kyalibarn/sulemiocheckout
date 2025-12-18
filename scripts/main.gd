extends Node2D

@onready var boss = $boss
@onready var ines = $ines

@onready var score_label = $scorelabel
@onready var colorrect = $ColorRect
@onready var losemessage = $ColorRect/RichTextLabel
@onready var losescore = $ColorRect/RichTextLabel/Label
@onready var restartbutton = $ColorRect/Button

@onready var fillessound = $filles
@onready var pernosound = $perno



var etat_boss = "dos"
var kissing = false
var score = 0
var playing = true

var appel_duration = 1.0      
var dos_duration = 5.0        
var raccroche_duration = 0.6 
var face_duration = 3.0       

var phase_timer = 0.0
var current_phase = "appel"

var points_per_second = 2.5     

func _ready():
	start_game()

func _process(delta):
	if playing :
		phase_timer -= delta
		if phase_timer <= 0:
			next_phase()

		if Input.is_action_pressed("kiss"):
			start_kiss()
		else:
			stop_kiss()

		if kissing and etat_boss == "dos":
			score += points_per_second * delta
			update_score_label()

func start_game():
	score = 0
	playing=true
	score_label.visible = true
	colorrect.visible = false
	losemessage.visible = false
	losescore.visible = false
	restartbutton.visible = false
	start_phase("appel")
	update_filles()
	update_score_label()


func start_phase(phase_name):
	current_phase = phase_name
	match phase_name:
		"appel":
			set_boss_state("appel")
			phase_timer = 1.5
			#pernosound.stream = appel
			#pernosound.play()
		"dos":
			set_boss_state("dos")
			#pernosound.stream=speech
			#pernosound.play()
			phase_timer = random_duration(dos_duration, 1.5)
		"raccroche":
			set_boss_state("raccroche")
			#pernosound.stream=null
			phase_timer = 1.5
		"face":
			set_boss_state("face")
			phase_timer = random_duration(face_duration, 1.0)

func next_phase():
	match current_phase:
		"appel":
			start_phase("dos")
		"dos":
			start_phase("raccroche")
		"raccroche":
			start_phase("face")
		"face":
			start_phase("appel")


func set_boss_state(new_state):
	etat_boss = new_state
	boss.animation = new_state
	boss.play()


func start_kiss():
	if not kissing:
		#fillessound.stream=soundkiss
		#fillessound.play()
		pass
	if etat_boss == "dos" or etat_boss == "appel" or etat_boss == "raccroche":
		kissing = true
	else:
		kissing = false
		#fillessound.stream=null
		set_boss_state("lose")
		lose()
	update_filles()

func stop_kiss():
	kissing = false
	fillessound.stream = null
	update_filles()

func update_filles():
	if kissing:
		ines.play('checkout')
	else:
		ines.play("idle")




func update_score_label():
	if score_label:
		score_label.text = "Score: " + str(int(score))

func lose():
	playing = false
	colorrect.visible = true
	losemessage.visible = true
	score_label.visible = false
	losescore.text = str(int(score))
	losescore.visible = true
	restartbutton.visible=true

func _on_button_pressed() -> void:
	start_game()


func random_duration(base_duration, variance):
	return base_duration + randf_range(-variance, variance)
