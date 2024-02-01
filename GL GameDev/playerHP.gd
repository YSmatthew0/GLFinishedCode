extends ProgressBar
const maxHP = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
		ProgressBar.value = get_node("../../Player1/Player").health
