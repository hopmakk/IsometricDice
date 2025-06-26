# IsometricDice  

**Isometric map generator** tech demo with top-down view.  
Procedural terrain built from noise-driven isometric tiles.  

![Demo](Presentation/Gameplay.mp4)

## 🔍 How It Works  
1. **Noise configuration** for terrain tiles.  
2. **Seed-based** noise texture generation.  
3. Matrix normalization (`[-1, 1]` → `[0, 1]`).  
4. **Gaussian radial masking** for map boundaries.  
5. Terrain assembly via **noise-tile mapping**.  

## 🛠 Current Progress  
- Core **procedural generation algorithm** implemented.  
- Basic isometric **tile system**.  
- Real-time **seed-controlled** map regeneration.  

## 📌 Roadmap  
- **Multi-layer noise** blending (height/biomes).

## ⚙️ Tech Stack  
**C# + Godot 4.3**
