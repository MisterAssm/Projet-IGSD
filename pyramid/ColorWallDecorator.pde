/**
 * Décorateur pour ajouter des couleurs dynamiques aux murs du labyrinthe
 */
class ColorWallDecorator {
  private final Labyrinthe labyrinthe;
  private final AffichageLabyrinthe affichage;
  
  public ColorWallDecorator(Labyrinthe labyrinthe, AffichageLabyrinthe affichage) {
    this.labyrinthe = labyrinthe;
    this.affichage = affichage;
  }
  
  /**
   * Applique les couleurs aux murs selon leur position
   */
  public void applyWallColors() {
    int size = labyrinthe.getSize();
    
    for (int j = 0; j < size; j++) {
      for (int i = 0; i < size; i++) {
        if (labyrinthe.getLabyrinthe()[j][i] == '#') {
          // Calcul des couleurs basé sur la position
          float r = map(j, 0, size-1, 0, 255);
          float g = map(i, 0, size-1, 0, 255);
          float b = abs(255 - r - g);
          
          // Appliquer la couleur aux faces visibles du mur
          colorWallFaces(i, j, color(r, g, b));
        }
      }
    }
  }
  
  /**
   * Colorie les faces visibles d'un mur
   */
  private void colorWallFaces(int x, int y, color wallColor) {
    int size = labyrinthe.getSize();
    char[][] laby = labyrinthe.getLabyrinthe();
    
    // Vérifier chaque face et appliquer la couleur si visible
    if (y == 0 || laby[y-1][x] == ' ') { // Face nord
      setWallFaceColor(x, y, 0, wallColor);
    }
    if (y == size-1 || laby[y+1][x] == ' ') { // Face sud
      setWallFaceColor(x, y, 1, wallColor);
    }
    if (x == 0 || laby[y][x-1] == ' ') { // Face ouest
      setWallFaceColor(x, y, 2, wallColor);
    }
    if (x == size-1 || laby[y][x+1] == ' ') { // Face est
      setWallFaceColor(x, y, 3, wallColor);
    }
  }
  
  /**
   * Modifie la couleur d'une face spécifique d'un mur
   */
  private void setWallFaceColor(int x, int y, int face, color c) {
    // Cette méthode nécessiterait d'accéder aux vertices des murs
    // Dans votre implémentation actuelle, vous devriez modifier:
    // - Soit directement dans AffichageLabyrinthe.createWallShape()
    // - Soit en post-process après la création des shapes
    
    // Solution alternative si on ne peut pas modifier les vertices:
    // On peut surcharger la méthode display() et appliquer un tint()
    // avant de dessiner les murs
  }
  
  /**
   * Version alternative qui utilise tint() pour colorier les murs
   */
  public void displayWithColors() {
    pushStyle();
    
    // Dessiner le sol normalement
    shape(affichage.floorShape, 0, 0);
    
    // Dessiner les murs avec coloration
    for (int j = 0; j < labyrinthe.getSize(); j++) {
      for (int i = 0; i < labyrinthe.getSize(); i++) {
        if (labyrinthe.getLabyrinthe()[j][i] == '#') {
          float r = map(j, 0, labyrinthe.getSize()-1, 0, 255);
          float g = map(i, 0, labyrinthe.getSize()-1, 0, 255);
          float b = abs(255 - r - g);
          
          pushMatrix();
          translate(i * (width/labyrinthe.getSize()), 
                   j * (height/labyrinthe.getSize()), 0);
          
          tint(r, g, b);
          // Dessiner le mur - nécessiterait d'avoir accès aux shapes individuelles
          popMatrix();
        }
      }
    }
    
    // Dessiner les plafonds normalement
    shape(affichage.ceilingShape, 0, 0);
    shape(affichage.wallCeilingShape, 0, 0);
    
    popStyle();
  }
}
