extends Node2D


# SELECTABLE ITEMS LOGIC

var selected_item = null

func _on_item_entered(item):
	# old
	if selected_item and selected_item != item: selected_item.scale = Vector2(1, 1)
	
	selected_item = item
	selected_item.scale = Vector2(1.1, 1.1)
	print("a")

func _on_item_exited(item):
	if selected_item == item:
		selected_item.scale = Vector2(1, 1)
		selected_item = null

# =========================
