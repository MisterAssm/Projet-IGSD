class Labyrinthe {
  
  private final char[][] labyrinthe;
  private final char[][][] cotes;
  private final int size;
  
  private final AffichageLabyrinthe affichageLabyrinthe;
  
  public Labyrinthe(int size, PImage texture, PImage textureSol) {
    this.labyrinthe = new char[size][size];
    this.cotes = new char[size][size][4];
    this.size = size;
    
    new GenerateurLabyrinthe().genererLabyrinthe(labyrinthe, cotes);
    
    this.affichageLabyrinthe = new AffichageLabyrinthe(texture, this,textureSol);
  }
  
  public boolean isWall(int x, int y) {
    if (x < 0 || x >= size || y < 0 || y >= size) {
      return true;
    }
    return labyrinthe[y][x] == '#';
  }
  
 public void afficherLabyrinthe() {
  for (int j = 0; j < size; j++) {
    for (int i = 0; i < size; i++) {
      print(labyrinthe[j][i]);
    }
    println("");
  }
}
  
  public char[][] getLabyrinthe() {
    return labyrinthe;
  }

   public char[][][] getCotes() {
    return cotes;
  }
  
  public int getSize() {
    return size;
  }
  
  public AffichageLabyrinthe getAffichage() {
    return affichageLabyrinthe;
  }
  
}
