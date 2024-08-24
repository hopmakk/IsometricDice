extends Node2D
class_name LevelData
# Информация об уровне



var ChapterNum: int
var LevelNum: int
var Name: String
var Size: Vector2
# + союзные персонажи
# + враги
# + погода
# + и тд



func _init(chapterNum: int, levelNum: int, name: String, size: Vector2):
	ChapterNum = chapterNum
	LevelNum = levelNum
	Name = name
	Size = size
	pass
