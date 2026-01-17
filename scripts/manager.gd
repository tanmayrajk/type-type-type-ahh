extends Node3D

var possible_targets: Array[String] = [
  "the","be","to","of","and","in","that","have",
  "it","for","not","on","with","he","as","you","do","at",
  "this","but","his","by","from","they","we","say","her","she",
  "or","an","will","my","one","all","would","there","their",
  "is","are","was","were","been","being","had","has","did","does",
  "can","could","should","may","might","must","shall","if","then",
  "else","when","while","where","why","how","what","who","whom",
  "which","because","so","than","too","very","just","only","even",
  "also","back","after","before","again","once","here","there",
  "now","then","always","never","often","sometimes","usually",
  "early","late","today","tomorrow","yesterday","time","year",
  "people","man","woman","child","day","thing","world","life",
  "hand","eye","place","work","week","case","point","government",
  "company","number","group","problem","fact","become","seem",
  "know","think","see","use","find","give","tell","work","call",
  "try","ask","need","feel","become","leave","put","mean","keep",
  "let","begin","help","talk","turn","start","show","hear","play",
  "run","move","live","believe","bring","happen","write","provide",
  "sit","stand","lose","pay","meet","include","continue","set",
  "learn","change","lead","understand","watch","follow","stop"
]

var available_targets: Array[Dictionary] = []
var selected_target: Dictionary = {}
var current_pos: int = 0

@export var max_player_health := 100
var player_health : int

func _ready() -> void:
	$player.set_main(self)
	player_health = max_player_health

func _process(delta: float) -> void:
	if selected_target.is_empty():
		return
	#print(selected_target)
	((selected_target.enemy as CharacterBody3D).find_child("body") as Sprite3D).modulate = Color("ff5bff")
	
func get_available_targets():
	return available_targets
	
func give_damage(amt: int):
	player_health -= amt
	if player_health <= 0:
		$player.queue_free()
