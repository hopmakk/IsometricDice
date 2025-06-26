using Godot;
using System.Linq;
using static System.Net.Mime.MediaTypeNames;

public partial class LevelDirector : Node2D
{
	private LevelsC1 _levelsC1;
	private PackedScene _packedTerrainGeneratorC1;


	public override void _Ready()
	{
        _levelsC1 = new LevelsC1();
		_packedTerrainGeneratorC1 = GD.Load<PackedScene>("res://Scenes/Level/TerrainGenerators/TerrainGeneratorC1.tscn");
    }

    int test;
	public override void _Process(double delta)
	{
		if (Input.IsKeyPressed(Key.Shift))
		{
            test++;
            if (test % 50 == 0)
                CreateAndShowLevel(1, 1);
		}
	}


    //Создать уровень и перейти к нему
    public void CreateAndShowLevel(int chapterNum, int levelNum)
	{
		var level = new Node2D();

        //// Заберем данные уровня
        //LevelData levelData = _levelsC1.Levels.Where(l => l.LevelNum == levelNum).First();
        //if (levelData == null)
        //	return;

        ulong id = level.GetInstanceId();
        var levelData = GD.Load("res://Scripts/Level/LevelData.cs");
        level.SetScript(levelData);
		var level1 = (LevelData)InstanceFromId(id);
        level1.Size = new Vector2(15, 15);
        //// присвоем уровню эти данные и поместим его на сцену
        //level.SetScript(levelData);
        AddChild(level1);

        // сгенерируем ландшафт
        var terrainGenerator = _packedTerrainGeneratorC1.Instantiate<TerrainGeneratorC1>();
        level1.AddChild(terrainGenerator);
		terrainGenerator.GenerateLevelTerrain(level1);
	}
}
