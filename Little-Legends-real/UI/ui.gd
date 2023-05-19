extends Control


# Called when the node enters the scene tree for the first time.
func _stone(num):
	get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer/RichTextLabel2").text = str(int(get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer/RichTextLabel2").text) - num)
func _wood(num):
	get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer2/RichTextLabel2").text = str(int(get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer2/RichTextLabel2").text) - num)
func _food(num):
	get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer3/RichTextLabel2").text = str(int(get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer3/RichTextLabel2").text) - num)
func _mana(num):
	get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer4/RichTextLabel2").text = str(int(get_node("VBoxContainer/Resources/HBoxContainer/VBoxContainer4/RichTextLabel2").text) - num)
