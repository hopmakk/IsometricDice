using Godot;
using System.Collections.Generic;

public partial class LevelsC1 : GodotObject
{
    public List<LevelData> Levels = new List<LevelData>()
    {
        new LevelData(1, 1, "Тест уровень 1", new Vector2(10,10))
    };
}
