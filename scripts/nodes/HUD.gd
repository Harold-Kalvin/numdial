extends MarginContainer

onready var screen = $"/root/Screen"
onready var game = $"/root/Game"
onready var timer = $"../Timer"
onready var score = $VBoxContainer/HBoxContainer/ScoreContainer/Score/ScoreCurrent
onready var max_score = $VBoxContainer/HBoxContainer/ScoreContainer/Score/ScoreMax
onready var level = $VBoxContainer/HBoxContainer/LevelContainer/Level
onready var objective = $VBoxContainer/HBoxContainer/ObjectiveContainer/Objective
onready var progress_bar = $VBoxContainer/TimerContainer/TimerProgressBar

const DIALED_COLOR = Color("#21183a")


func _ready():
    # scale and position HUD with main block (aspect ratio)
    rect_position = screen.main_block_position
    var scale_component = screen.main_block_size.x / rect_size.x
    set_scale(Vector2(scale_component, scale_component))
    
    # progress bar timer
    progress_bar.max_value = timer.wait_time
    progress_bar.value = progress_bar.max_value

    # connect game signals
    game.connect("score_changed", self, "_on_score_changed")
    game.connect("max_score_changed", self, "_on_max_score_changed")
    game.connect("level_changed", self, "_on_level_changed")
    game.connect("objective_changed", self, "_on_objective_changed")
    game.connect("dial_succeded", self, "_on_dial_succeded")

    # align objective (RichTextLabel) 
    yield(get_tree(), "idle_frame")
    _align_objective()


func _process(_delta):
    progress_bar.value = timer.time_left


func _align_objective():
    objective.rect_min_size = objective.get_font("normal_font").get_string_size(objective.text)


func _on_score_changed(new_score):
    score.text = str(new_score).pad_zeros(3)


func _on_max_score_changed(new_max_score):
    max_score.text = "/"+str(new_max_score).pad_zeros(3)


func _on_level_changed(new_level):
    level.text = str(new_level)


func _on_objective_changed(new_objective):
    objective.text = str(new_objective)
    _align_objective()


func _on_dial_succeded():
    objective.clear()

    # change color of dialed numbers
    objective.push_color(DIALED_COLOR)
    objective.add_text(game.get_dialed())
    objective.pop()

    # keep undialed numbers unchanged
    var to_be_dialed = game.get_objective().right(game.get_dialed().length())
    objective.add_text(to_be_dialed)

    _align_objective()
