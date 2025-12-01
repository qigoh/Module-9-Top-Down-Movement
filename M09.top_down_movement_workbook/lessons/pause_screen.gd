@tool
extends Control
@onready var color_rect: ColorRect = %ColorRect
@onready var ui_panel_container: PanelContainer = %UIPanelContainer

@export_range(0.0,1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount
	
func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0
	
