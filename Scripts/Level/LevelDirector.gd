extends Node2D
class_name LevelDirector
# Создает и управляет уровнями



@onready var _levelListC1: LevelListC1 = LevelListC1.new()
#@onready var _packedLevel: PackedScene = preload("res://Scenes/Level/Level.tscn")
@onready var _packedTerrainGeneratorC1: PackedScene = preload("res://Scenes/Level/TerrainGenerators/TerrainGeneratorC1.tscn")
var _currentLevel: LevelData

func fdsfsd():
	print()
	
	print()

func _process(delta):
	if Input.is_key_pressed(KEY_SHIFT):
		#---	 
		#var landscapeX : int = int(get_node("/root/Main/UI/Control/x_tb").text)
		#var landscapeY : int = int(get_node("/root/Main/UI/Control/y_tb").text)
		#GenerateMap(Vector2(landscapeX, landscapeY))
		#---
		CreateAndShowLevel(1,1)
		pass



# Создать уровень и перейти к нему
func CreateAndShowLevel(chapterNum: int, levelNum: int):
	# Создадим узел и добавим в него экземпляр скрипта нужного уровня
	var level = Node2D.new()
	var levelData: LevelData
	for i in range(_levelListC1.Levels.size()):
		if _levelListC1.Levels[i].ChapterNum == chapterNum && _levelListC1.Levels[i].LevelNum == levelNum:
			levelData = _levelListC1.Levels[i]
			break
	level.set_script(levelData)
	
	# Сгенерируем ландшафт
	var terrainGeneratorC1 : TerrainGeneratorC1 = _packedTerrainGeneratorC1.instantiate()
	level.add_child(terrainGeneratorC1)
	terrainGeneratorC1.GenerateLevelTerrain(level)
	pass
