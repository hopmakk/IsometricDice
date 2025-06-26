using Godot;

public partial class LevelData : Node2D
{
	public int ChapterNum { get; set; }
	public int LevelNum { get; set; }
	public string LevelTitle { get; set; }
	public Vector2 Size { get; set; }


    public LevelData()
    {
    }

    
    public LevelData(int chapterNum, int levelNum, string levelTitle, Vector2 size)
    {
        ChapterNum = chapterNum;
        LevelNum = levelNum;
        LevelTitle = levelTitle;
        Size = size;
    }

}
