extends Control

@onready var interact: PanelContainer = $interact
@onready var left: PanelContainer = $left
@onready var right: PanelContainer = $right

func _ready() -> void:
	interact.gui_input.connect(_on_panel_input.bind("interact"))
	left.gui_input.connect(_on_panel_input.bind("move_left"))
	right.gui_input.connect(_on_panel_input.bind("move_right"))


func _on_panel_input(event: InputEvent, action_name: String) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
		var action_event := InputEventAction.new()
		action_event.action = action_name
		action_event.pressed = event.pressed
		Input.parse_input_event(action_event)
