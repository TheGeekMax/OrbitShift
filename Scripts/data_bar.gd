extends HBoxContainer

@export var template: Control
var nodes_array: Array[Control] = []
var count = 0

func _ready():
	var childs = get_children()
	for child in childs:
		child.hide()
	

func add_template():
	var new_box = template.duplicate()
	new_box.show()
	add_child(new_box)
	nodes_array.append(new_box)
	
func remove_last():
	var last = nodes_array.pop_back()
	last.queue_free()

func define_value(value:int):
	if count > value:
		for i in (count-value):
			remove_last()
	elif count < value:
		for i in (value-count):
			add_template()
	count = value
	
	#set size
	size = template.size*Vector2(count,1)+Vector2(5,0)*Vector2(count-1,1)
