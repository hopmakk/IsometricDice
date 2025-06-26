using Godot;

public partial class TileTypeInfo : GodotObject
{
    public string Name { get; set; }
    public Vector2I TilesetCoords { get; set; }
    public float NoiseBound { get; set; }


    public TileTypeInfo(string name, Vector2I tilesetCoords, float noiseBound)
    {
        Name = name;
        TilesetCoords = tilesetCoords;
        NoiseBound = noiseBound;
    }

}
