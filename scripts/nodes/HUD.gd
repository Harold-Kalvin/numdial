extends MarginContainer

onready var screen = $"/root/Screen"
onready var game = $"/root/Game"
onready var score = $VBoxContainer/HBoxContainer/ScoreContainer/Score/ScoreCurrent
onready var score_for_next_level = $VBoxContainer/HBoxContainer/ScoreContainer/Score/ScoreForNextLevel
onready var level = $VBoxContainer/HBoxContainer/LevelContainer/Level
onready var objective = $VBoxContainer/HBoxContainer/ObjectiveContainer/Objective


func _ready():
    # scale and position HUD with main block (aspect ratio)
    rect_position = screen.main_block_position
    var scale_component = screen.main_block_size.x / rect_size.x
    set_scale(Vector2(scale_component, scale_component))
    
    # connect game signals
    game.connect("score_changed", self, "_on_score_changed")
    game.connect("score_for_next_level_changed", self, "_on_score_for_next_level_changed")
    game.connect("level_changed", self, "_on_level_changed")
    game.connect("objective_changed", self, "_on_objective_changed")


func _on_score_changed(new_score):
    score.text = str(new_score).pad_zeros(3)


func _on_score_for_next_level_changed(new_score_for_next_level):
    score_for_next_level.text = "/"+str(new_score_for_next_level).pad_zeros(3)


func _on_level_changed(new_level):
    level.text = str(new_level)


func _on_objective_changed(new_objective):
    objective.text = str(new_objective)
