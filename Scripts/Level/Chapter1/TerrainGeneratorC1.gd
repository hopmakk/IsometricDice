extends Node2D
class_name TerrainGeneratorC1
# Генерирует ландшафт уровня.



const LANDSCAPE_SIZE: Vector2 = Vector2(10,10)

var _noise: Noise
var _groundTileMap: TileMapLayer
var _underwaterTileMap: TileMapLayer



func _ready():
	_groundTileMap = $Ground
	_underwaterTileMap = $Underwater
	_noise = $NoiseSprite.texture.noise
	pass



func GenerateLevelTerrain(levelData: LevelData):
	GenerateMap(levelData.Size)
	pass



# Сгенерировать карту
func GenerateMap(landscapeSize: Vector2):
	var rnd: RandomNumberGenerator = RandomNumberGenerator.new()
	
	var GroundTileTypes : Array[TileTypeInfo]
	GroundTileTypes.append(TileTypeInfo.new("земля_1", Vector2i(0,1), 0.65))
	GroundTileTypes.append(TileTypeInfo.new("земля_2", Vector2i(1,1), 0.45))
	GroundTileTypes.append(TileTypeInfo.new("земля_3", Vector2i(2,1), 0.35))
	GroundTileTypes.append(TileTypeInfo.new("мох длинный", Vector2i(1,3), 0.32))
	GroundTileTypes.append(TileTypeInfo.new("мох короткий", Vector2i(0,3), 0.25))
	GroundTileTypes.append(TileTypeInfo.new("пустота", Vector2i(2,3), 0))
	
	var UnderwaterTileTypes : Array[TileTypeInfo]
	UnderwaterTileTypes.append(TileTypeInfo.new("земля_1", Vector2i(0,2), 0.65))
	UnderwaterTileTypes.append(TileTypeInfo.new("земля_2", Vector2i(1,2), 0.45))
	UnderwaterTileTypes.append(TileTypeInfo.new("земля_3", Vector2i(2,2), 0.35))
	UnderwaterTileTypes.append(TileTypeInfo.new("мох длинный", Vector2i(1,3), 0.27))
	UnderwaterTileTypes.append(TileTypeInfo.new("мох короткий", Vector2i(0,3), 0.25))
	UnderwaterTileTypes.append(TileTypeInfo.new("пустота", Vector2i(2,3), 0))
	
	_noise.seed = rnd.randi_range(-100,100) # рандомизируем шум
	var noiseMatrix = NoiseToMatrixWithNormalize(_noise, landscapeSize) # переведем шум в формат матрицы и нормализуем с -1..1 до 0..1
	var groundNoiseGaussMatrix = ApplyGaussFunc(noiseMatrix, 1.5, landscapeSize) # обработка функцией гаусса для земли
	var underwaterNoiseGaussMatrix = ApplyGaussFunc(noiseMatrix, 5.0, landscapeSize) # обработка функцией гаусса для подводного ландшафта
	
	# расставляем тайлы
	PutTiles(_groundTileMap, groundNoiseGaussMatrix, Vector2i.ZERO, GroundTileTypes)
	# расставляем тайлы под водой
	PutTiles(_underwaterTileMap, underwaterNoiseGaussMatrix, Vector2i(1,1), UnderwaterTileTypes)
	pass



# Нарисовать тайлы на тайлмапе, offset нужен чтобы сдвинуть отображение сетки на заданный вектор
func PutTiles(tileMap: TileMapLayer, noiseMatrix: Array, offset: Vector2i, tileTypesMas: Array[TileTypeInfo]):
	for x in range(noiseMatrix.size()):
		for y in range(noiseMatrix[x].size()):
			for index in range(tileTypesMas.size()):
				if noiseMatrix[x][y] > tileTypesMas[index].NoiseBound:
					tileMap.set_cell(Vector2i(x,y) + offset, 0, tileTypesMas[index].TilesetCoords)
					break
	pass



# Шум превратить в матрицу float'ов с нормализацией с -1..1 до 0..1
func NoiseToMatrixWithNormalize(noise: Noise, landscapeSize: Vector2) -> Array:
	var noiseMatrix = []
	for x in range(landscapeSize.x):
		noiseMatrix.append([])
		for y in range(landscapeSize.y):
			# инвертируем потому что в питоне нет нормальных двумерных массивов.
			var noiseValue = _noise.get_noise_2d(y,x)
			# нормализуем с -1..1 до 0..1
			noiseValue = (noiseValue + 1) / 2
			noiseMatrix[x].append(noiseValue) 
	return noiseMatrix



# Применить функцию Гаусса, чтобы радиально ограничить расположение плиток
func ApplyGaussFunc(noiseMatrix: Array, power: float, landscapeSize: Vector2) -> Array:
	# копируем матрицу так, чтобы случайно не забрать ее по ссылке
	var newNoiseMatrix: = []
	for x in range(noiseMatrix.size()):
		newNoiseMatrix.append([])
		for y in range(noiseMatrix[x].size()):
			newNoiseMatrix[x].append(noiseMatrix[x][y])
	# Применяем функцию Гаусса
	for x in range(newNoiseMatrix.size()):
		for y in range(newNoiseMatrix[x].size()):
			var distance: float = pow(x - landscapeSize.x / 2, 2) + pow(y - landscapeSize.y / 2, 2)
			var gaussValue: float = exp(-distance / (pow(landscapeSize.x / 2, 2) / 3))
			newNoiseMatrix[x][y] *= gaussValue * power
	return newNoiseMatrix



# класс для хранения информации о типе тайла
class TileTypeInfo:
	var Name: String
	var TilesetCoords: Vector2i
	var NoiseBound: float
	
	func _init(name: String, tilesetCoords: Vector2i, noiseBound: float):
		Name = name
		TilesetCoords = tilesetCoords
		NoiseBound = noiseBound
		pass
