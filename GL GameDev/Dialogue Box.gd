extends ColorRect
 
@export var dialogPath = "res://Frog Dialogue.json"
@export var textSpeed:float = 1
 
var dialog
 
var phraseNum
var finished
var called

func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	phraseNum = 0
	finished = false
	called = false
 
func _process(_delta):
	$Indicator.visible = finished
	if $"../../Mobs/Frog".attack == true:
		if called == false:
			nextPhrase()
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
 
func getDialog() -> Array:
	var output= JSON.parse_string(FileAccess.get_file_as_string(dialogPath))
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
 
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		queue_free()
		called = true
		return
	
	else:
		finished = false
		
		$Name.bbcode_text = dialog[phraseNum]["Name"]
		$Text.bbcode_text = dialog[phraseNum]["Text"]
		
		$Text.visible_characters = 0
		
		
		while $Text.visible_characters < len($Text.text):
			$Text.visible_characters += 1
			
			$Timer.start()
			await $Timer.timeout
		
		called = true
		finished = true
		phraseNum += 1
		return
