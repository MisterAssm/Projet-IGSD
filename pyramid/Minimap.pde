import processing.opengl.*;

/**
 * Classe Minimap - Affiche une représentation 3D du labyrinthe découvert par le joueur
 * Permet la navigation et visualisation progressive du labyrinthe
 */
public class Minimap {
  // ==================== CONSTANTES ====================
  private static final int VIEW_DISTANCE = 3;  // Rayon de visibilité autour du joueur
  
  // ==================== ATTRIBUTS ====================
  private Labyrinthe labyrinthe;          // Référence au labyrinthe
  private int boxSize;                    // Taille d'une case sur la minimap
  private boolean[][] discovered;         // Zones découvertes par le joueur
  private PShader shader;                 // Shader pour les effets visuels
  
  // Position du joueur
  private int playerX;
  private int playerY;
  
  // Contrôles de caméra
  private float cameraRotX = 0;
  private float cameraRotY = 0;
  private float zoom = 0.21;
  
  /**
   * Constructeur de la minimap
   * @param labyrinthe Le labyrinthe à représenter
   */
  public Minimap(Labyrinthe labyrinthe) {
    this.labyrinthe = labyrinthe;
    this.shader = loadShader("LabyColor.glsl", "LabyTexture.glsl");
    this.boxSize = (width / labyrinthe.getSize()) - 5;
    
    // Initialisation de la matrice des zones découvertes
    this.discovered = new boolean[labyrinthe.getSize()][labyrinthe.getSize()];
    
    // Position initiale du joueur
    this.playerX = 1;
    this.playerY = 0;
    
    // Marquer la zone initiale comme découverte
    updateDiscoveredArea();
  }
  
public void drawMinimap() {
  // Sauvegarder l'état actuel du système de coordonnées
  pushMatrix();
  
  // Passer en mode HUD : réinitialiser la caméra et la perspective
  camera();
  perspective();
  
  // Désactiver le test de profondeur pour que la minimap soit rendue par-dessus le reste
  hint(DISABLE_DEPTH_TEST);
  
  // Définir la taille et la position de la minimap dans le coin en haut à gauche
  int minimapSize = min(width, height) / 4;  // Taille de la minimap
  int offsetX = 20;                          // Marge depuis le bord gauche
  int offsetY = 20;                          // Marge depuis le bord supérieur
  
  // Fond de la minimap
  fill(0, 0, 0, 150);  // Fond noir semi-transparent
  noStroke();
  rect(offsetX - 10, offsetY - 10, minimapSize + 20, minimapSize + 20, 5);
  
  // Configuration de base pour le dessin de la minimap
  pushMatrix();
  setupLighting();
  shader(shader);
  
  // Configuration de la caméra de la minimap
  pushMatrix();
  noStroke();
  setupCamera();
  
  // Dessiner le labyrinthe et le joueur
  drawLabyrinth();
  drawPlayer();
  
  popMatrix();
  resetShader();
  popMatrix();
  
  // Réactiver le test de profondeur
  hint(ENABLE_DEPTH_TEST);
  
  popMatrix();
}

  
  /**
   * Configure l'éclairage de la scène
   */
  private void setupLighting() {
    ambientLight(60, 60, 60);
    directionalLight(200, 200, 200, 0, 0, -1);
    pointLight(150, 150, 150, 
               playerX * boxSize + boxSize/2, 
               playerY * boxSize + boxSize/2, 
               boxSize * 2);
  }
  
  /**
   * Configure la caméra (position, rotation, zoom)
   */
  private void setupCamera() {
    rotateX(cameraRotX);
    rotateY(cameraRotY);
    scale(zoom);
    translate(boxSize, boxSize, 0);
  }
  
  /**
   * Dessine l'ensemble du labyrinthe (murs et sols)
   */
  private void drawLabyrinth() {
    // Couleurs des coins pour le dégradé
    color topLeft = color(33, 28, 132);     // Bleu
    color topRight = color(232, 63, 37);    // Rouge
    color bottomLeft = color(96, 181, 255); // Cyan
    color bottomRight = color(248, 237, 140); // Jaune
    
    // Parcourir chaque case du labyrinthe
    for (int j = 0; j < labyrinthe.getSize(); j++) {
      for (int i = 0; i < labyrinthe.getSize(); i++) {
        pushMatrix();
        translate(j * boxSize, i * boxSize, 0);
        
        // Ne dessiner que les cases découvertes
        if (discovered[i][j]) {
          if (labyrinthe.getLabyrinthe()[i][j] == '#') {
            // Case mur - Appliquer un dégradé de couleur
            color wallColor = calculateGradientColor(i, j, topLeft, topRight, bottomLeft, bottomRight);
            fill(wallColor);
            noStroke();
            drawCube();
          } else {
            // Case sol
            fill(58, 58, 58);
            drawFloor();
          }
        } else {
          // Case non découverte - semi-transparente
          fill(10, 10, 10, 20);
          drawFloor();
        }
        
        popMatrix();
      }
    }
  }
  
  /**
   * Calcule la couleur d'un mur selon sa position (dégradé)
   */
  private color calculateGradientColor(int i, int j, color topLeft, color topRight, 
                                      color bottomLeft, color bottomRight) {
    float horizAmount = (float) j / (labyrinthe.getSize() - 1);
    float vertAmount = (float) i / (labyrinthe.getSize() - 1);
    
    color topColor = lerpColor(topLeft, topRight, horizAmount);
    color bottomColor = lerpColor(bottomLeft, bottomRight, horizAmount);
    return lerpColor(topColor, bottomColor, vertAmount);
  }
  
  /**
   * Dessine un cube représentant un mur
   */
  private void drawCube() {
    beginShape(QUADS);
    
    // Face avant
    vertex(0, 0, boxSize);
    vertex(boxSize, 0, boxSize);
    vertex(boxSize, boxSize, boxSize);
    vertex(0, boxSize, boxSize);
    
    // Face arrière
    vertex(0, 0, 0);
    vertex(boxSize, 0, 0);
    vertex(boxSize, boxSize, 0);
    vertex(0, boxSize, 0);
    
    // Face gauche
    vertex(0, 0, 0);
    vertex(0, 0, boxSize);
    vertex(0, boxSize, boxSize);
    vertex(0, boxSize, 0);
    
    // Face droite
    vertex(boxSize, 0, 0);
    vertex(boxSize, 0, boxSize);
    vertex(boxSize, boxSize, boxSize);
    vertex(boxSize, boxSize, 0);
    
    // Face inférieure
    vertex(0, 0, 0);
    vertex(boxSize, 0, 0);
    vertex(boxSize, 0, boxSize);
    vertex(0, 0, boxSize);
    
    // Face supérieure
    vertex(0, boxSize, 0);
    vertex(boxSize, boxSize, 0);
    vertex(boxSize, boxSize, boxSize);
    vertex(0, boxSize, boxSize);
    
    endShape();
  }
  
  /**
   * Dessine un sol (une face plane)
   */
  private void drawFloor() {
    beginShape(QUADS);
    vertex(0, 0, 0);
    vertex(boxSize, 0, 0);
    vertex(boxSize, boxSize, 0);
    vertex(0, boxSize, 0);
    endShape();
  }
  
  /**
   * Dessine la représentation du joueur
   */
  private void drawPlayer() {
    pushMatrix();
    
    // Positionner au centre de la case du joueur
    translate(playerX * boxSize + boxSize / 2, 
              playerY * boxSize + boxSize / 2, 
              boxSize / 2);
    
    // Effet de pulsation pour le joueur
    float pulseSize = boxSize / 3 + sin(frameCount * 0.1) * boxSize / 20;
    
    // Apparence du joueur
    fill(64, 224, 208, 200);  // Turquoise semi-transparent
    emissive(20, 80, 80);     // Effet lumineux
    noStroke();
    sphere(pulseSize);
    
    // Réinitialiser les paramètres graphiques
    emissive(0, 0, 0);
    stroke(0);
    
    popMatrix();
  }
  
  /**
   * Met à jour les zones découvertes autour du joueur
   */
  public void updateDiscoveredArea() {
    // Parcourir la zone autour du joueur selon la distance visible
    for (int y = max(0, playerY - VIEW_DISTANCE); 
         y <= min(labyrinthe.getSize() - 1, playerY + VIEW_DISTANCE); 
         y++) {

      for (int x = max(0, playerX - VIEW_DISTANCE); 
           x <= min(labyrinthe.getSize() - 1, playerX + VIEW_DISTANCE); 
           x++) {
           
        // Calcul de la distance de Manhattan
        int distance = abs(x - playerX) + abs(y - playerY);
        
        // Marquer comme découvert si dans le rayon visible
        if (distance <= VIEW_DISTANCE) {
          discovered[y][x] = true;
        }
      }
    }
  }
  
  /**
   * Gère les touches clavier pour contrôler la caméra de la minimap
   * @param moved Si le joueur s'est déplacé
   * @param positionX Nouvelle position X du joueur
   * @param positionY Nouvelle position Y du joueur
   */
  public void performKeyPressed(boolean moved, int positionX, int positionY) {
    // Contrôles de la caméra
    if (key == 'a' || key == 'A') {
      zoom *= 1.1;  // Zoom avant
      System.out.println("zoom = " + zoom);
    }
    if (key == 'e' || key == 'E') {
      zoom *= 0.9;  // Zoom arrière
      System.out.println("zoom = " + zoom);
    }
    if (key == 'q' || key == 'Q') {
      cameraRotY -= 0.1;  // Rotation gauche
    }
    if (key == 'd' || key == 'D') {
      cameraRotY += 0.1;  // Rotation droite
    }
    if (key == 'z' || key == 'Z') {
      cameraRotX -= 0.1;  // Rotation haut
    }
    if (key == 's' || key == 'S') {
      cameraRotX += 0.1;  // Rotation bas
    }
    
    // Mettre à jour position du joueur et zone découverte si déplacement
    if (moved) {
      this.playerX = positionX;
      this.playerY = positionY;
      updateDiscoveredArea();
    }
  }
  
  /**
   * Met à jour la position du joueur (sans contrôle des touches)
   * @param positionX Nouvelle position X
   * @param positionY Nouvelle position Y
   */
  public void updatePlayerPosition(int positionX, int positionY) {
    this.playerX = positionX;
    this.playerY = positionY;
    updateDiscoveredArea();
  }
  
  /**
   * Réinitialise les paramètres de la caméra
   */
  public void resetCamera() {
    this.cameraRotX = 0;
    this.cameraRotY = 0;
    this.zoom = 0.21;
  }
}
