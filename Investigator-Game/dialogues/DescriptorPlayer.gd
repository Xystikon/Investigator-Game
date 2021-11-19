extends CanvasLayer


var NPCName = ""

var dialogues = []
var current_dialogue_id = 0
var is_dialogue_active = false

var dialogue_file

var item_id = 0
var message_num = -1

var display = ""
var typing_speed = .05
var current_char = 0

func _ready():
	$NinePatchRect.visible = false

func play(dialogue, name):
	self.dialogue_file = dialogue
	if is_dialogue_active:
		return
	
	dialogues=load_dialogue()
	
	for item in dialogues:
		if item["name"] == name:
			item_id = item["id"]
			if message_num+1 < len(dialogues[item_id]["dialogue"]):
				message_num += 1
			turn_off_player()
			is_dialogue_active = true
			$NinePatchRect.visible = true
			current_dialogue_id = 0
			
			display = ""
			current_char = 0
			$next_char.set_wait_time(typing_speed)
			$next_char.start()
	
func _input(event):
	if not is_dialogue_active:
		return
	
	if event.is_action_pressed("game_interact"):
		next_line()
		
func next_line():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogues[item_id]["dialogue"][message_num]["text"]):
		display=""
		$NinePatchRect/Message.text = display
#		$NinePatchRect/Name.text = ""
		$end_dialogue.start()
		$NinePatchRect.visible = false
		turn_on_player()
		$next_char.stop()
		return
	else:
		display = ""
		current_char = 0
		$next_char.set_wait_time(typing_speed)
		$next_char.start()
	
func load_dialogue():
	var file = File.new()
	if file.file_exists(self.dialogue_file):
		file.open(self.dialogue_file, file.READ)
		return parse_json(file.get_as_text())

func _on_end_dialogue_timeout():
	is_dialogue_active = false

func _on_next_char_timeout():
	if (current_char < len(dialogues[item_id]["dialogue"][message_num]["text"][current_dialogue_id]["text"])):
		var next_char = dialogues[item_id]["dialogue"][message_num]["text"][current_dialogue_id]["text"][current_char]
		display += next_char
		
#		$NinePatchRect/Name.text = dialogues[item_id]["dialogue"][message_num]["text"][current_dialogue_id]["name"]
		$NinePatchRect/Message.text = display
		current_char += 1
	else:
		$next_char.stop()

func turn_off_player():
	var player = get_tree().get_root().find_node("Player", true, false)
	if player:
		player.set_active(false)

func turn_on_player():
	var player = get_tree().get_root().find_node("Player", true, false)
	if player:
		player.set_active(true)

#var display = ""
#var typing_speed = .05
#var current_char = 0
#
#var text = ""
#var done = true
#var talking_to = false
#
#func _ready():
#	$NinePatchRect.visible = false
#
#func _input(event):
#	if event.is_action_pressed("game_interact") and done and talking_to:
#		$NinePatchRect/Message.text = ""
#		$NinePatchRect.visible = false
#		turn_on_player()
#		talking_to = false
#
#func interact(input_text):
#	talking_to = true
#	done = false
#	$NinePatchRect.visible = true
#	self.text = input_text
#	display = ""
#	current_char = 0
#	turn_off_player()
#	$next_char.set_wait_time(typing_speed)
#	$next_char.start()
#
#func _on_next_char_timeout():
#	if(current_char < len(text)):
#		var next_char = text[current_char]
#		display+=next_char
#
#		$NinePatchRect/Message.text=display
#		current_char += 1
#	else:
#		$next_char.stop()
#		$end_dialogue.start()
#
#func _on_end_dialogue_timeout():
#	done = true
#
#func turn_off_player():
#	var player = get_tree().get_root().find_node("Player", true, false)
#	if player:
#		player.set_active(false)
#
#func turn_on_player():
#	var player = get_tree().get_root().find_node("Player", true, false)
#	if player:
#		player.set_active(true)
