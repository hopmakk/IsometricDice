using Godot;
using System;
using System.Collections.Generic;

public partial class TerrainGeneratorC1 : Node2D
{
	private FastNoiseLite _noise;
	private TileMapLayer _groundTileMap;
	private TileMapLayer _underwaterTileMap;
	private List<TileTypeInfo> _groundTileTypes;
	private List<TileTypeInfo> _underwaterTileTypes;
	private RandomNumberGenerator _randomNumberGenerator;


	public override void _Ready()
	{
		_groundTileMap = GetNode<TileMapLayer>("Ground");
        _underwaterTileMap = GetNode<TileMapLayer>("Underwater");
		_noise = (FastNoiseLite)((NoiseTexture2D)GetNode<Sprite2D>("NoiseSprite").Texture).Noise;
        _randomNumberGenerator = new RandomNumberGenerator();
        _groundTileTypes = new List<TileTypeInfo>();
        _underwaterTileTypes = new List<TileTypeInfo>();
        SetTileTypes();

        _groundTileMap.SetCell(new Vector2I(-1, -1), 0, new Vector2I(2,2));
    }


	private void SetTileTypes()
	{
		_groundTileTypes.Add(new TileTypeInfo("земля 1", new Vector2I(0, 1), 0.65f));
		_groundTileTypes.Add(new TileTypeInfo("земля 2", new Vector2I(1, 1), 0.45f));
		_groundTileTypes.Add(new TileTypeInfo("земля 3", new Vector2I(2, 1), 0.35f));
		_groundTileTypes.Add(new TileTypeInfo("мох длинный", new Vector2I(1, 3), 0.32f));
		_groundTileTypes.Add(new TileTypeInfo("мох короткий", new Vector2I(0, 3), 0.25f));
		_groundTileTypes.Add(new TileTypeInfo("пустота", new Vector2I(2, 3), 0));

        _underwaterTileTypes.Add(new TileTypeInfo("земля 1", new Vector2I(0, 2), 0.65f));
        _underwaterTileTypes.Add(new TileTypeInfo("земля 2", new Vector2I(1, 2), 0.45f));
        _underwaterTileTypes.Add(new TileTypeInfo("земля 3", new Vector2I(2, 2), 0.35f));
        _underwaterTileTypes.Add(new TileTypeInfo("мох длинный", new Vector2I(1, 3), 0.27f));
        _underwaterTileTypes.Add(new TileTypeInfo("мох короткий", new Vector2I(0, 3), 0.25f));
        _underwaterTileTypes.Add(new TileTypeInfo("пустота", new Vector2I(2, 3), 0));
    }

	
	public void GenerateLevelTerrain(LevelData levelData)
	{
		Generate(levelData.Size);
	}


    // Сгенерировать карту
    private void Generate(Vector2 landscapeSize)
    {
		_noise.Seed = _randomNumberGenerator.RandiRange(-1000,1000);
        var noiseMatrix = NoiseToMatrixWithNormalize(_noise, landscapeSize);
        var groundNoiseGaussMatrix = ApplyGaussFunc(noiseMatrix, 1.5f, landscapeSize);
        var underwaterNoiseGaussMatrix = ApplyGaussFunc(noiseMatrix, 5.0f, landscapeSize);

        PutTiles(_groundTileMap, groundNoiseGaussMatrix, new Vector2I(0,0), landscapeSize, _groundTileTypes);
        PutTiles(_underwaterTileMap, underwaterNoiseGaussMatrix, new Vector2I(1,1), landscapeSize, _underwaterTileTypes);
    }


    // Шум превратить в матрицу float с нормализацией с -1..1 до 0..1
    private float[,] NoiseToMatrixWithNormalize(Noise noise, Vector2 landscapeSize)
    {
        var noiseMatrix = new float[Convert.ToInt32(landscapeSize.X), Convert.ToInt32(landscapeSize.Y)];

        for (int i = 0; i < landscapeSize.X; i++)
        {
            for (int j = 0; j < landscapeSize.Y; j++)
            {
                var noiseValue = noise.GetNoise2D(i,j);
                // нормализуем с -1..1 до 0..1
                noiseValue = (noiseValue + 1) / 2;
                noiseMatrix[i, j] = noiseValue;
            }
        }
        return noiseMatrix;
    }


    // Применить функцию Гаусса, чтобы радиально ограничить расположение плиток
    private float[,] ApplyGaussFunc(float[,] noiseMatrix, float power, Vector2 landscapeSize)
    {
        var newNoiseMatrix = (float[,])noiseMatrix.Clone();

        for (int x = 0; x < landscapeSize.X; x++)
        {
            for (int y = 0; y < landscapeSize.Y; y++)
            {
                var distance = Mathf.Pow(x - landscapeSize.X / 2f, 2) + Mathf.Pow(y - landscapeSize.Y / 2f, 2);
                var gaussValue = Mathf.Exp(-distance / (Mathf.Pow(landscapeSize.X / 2f, 2) / 3));
                if (x == 5 && y == 5)
                    GD.Print("до    " + newNoiseMatrix[x, y] + $" {power}");
                newNoiseMatrix[x, y] *= gaussValue * power;
                if (x == 5 && y == 5)
                    GD.Print("после " + newNoiseMatrix[x, y] + $" {power}" + "\n------\n");
            }
        }
        return newNoiseMatrix;
    }
    

    // Нарисовать тайлы на тайлмапе, offset нужен чтобы сдвинуть отображение сетки на заданный вектор
    private void PutTiles(TileMapLayer tileMap, float[,] noiseMatrix, Vector2I offset, Vector2 landscapeSize, List<TileTypeInfo> tileTypesMas)
    {
        for (int x = 0; x < landscapeSize.X; x++)
        {
            for (int y = 0; y < landscapeSize.Y; y++)
            {
                for (int i = 0; i < tileTypesMas.Count; i++)
                {
                    if (noiseMatrix[x,y] > tileTypesMas[i].NoiseBound)
                    {
                        tileMap.SetCell(new Vector2I(x, y) + offset, 0, tileTypesMas[i].TilesetCoords);
                        break;
                    }
                }
            }
        }
    }
}
