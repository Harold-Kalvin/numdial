extends Node2D

var num_button = preload("res://scenes/NumButton.tscn")


func _ready():
    var button = num_button.instance()
    button.position = Vector2(300, 300)
    button.init("1")
    add_child(button)
