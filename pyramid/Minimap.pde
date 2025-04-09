public class Minimap {
  // ==================== CONSTANTES ====================
  private static final int VIEW_DISTANCE = 3;  // Rayon de visibilité autour du joueur
  
  // ==================== ATTRIBUTS ====================
  
  private Labyrinthe labyrinthe;
  private int boxSize;
  private boolean[][] discovered;
  private PShader shader;
  
  // Position du joueur
  private int playerX;
  private int playerY;
  
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
    pushMatrix();
  
    // Passer en mode HUD : réinitialiser la caméra et la perspective
    camera();
    ortho();
  
    int offsetX = 20; // Marge depuis le bord gauche
    int offsetY = 20; // Marge depuis le bord supérieur
  
    pushMatrix();
    setupLighting();
    shader(shader);
  
    pushMatrix();
    translate(offsetX, offsetY);  // Positionner la minimap dans le coin
    scale(0.2);
  
    // Dessiner le labyrinthe et le joueur
    drawLabyrinth();
    drawPlayer();
  
    popMatrix();
    resetShader();
    popMatrix();
  
    popMatrix();
  }
  
  private void setupLighting() {
    ambientLight(60, 60, 60);
    directionalLight(200, 200, 200, 0, 0, -1);
    pointLight(150, 150, 150, 
               playerX * boxSize + boxSize/2, 
               playerY * boxSize + boxSize/2, 
               boxSize * 2);
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
   * Dessine un sol (face plane)
   */
  private void drawFloor() {
    beginShape(QUADS);
    vertex(0, 0, 0);
    vertex(boxSize, 0, 0);
    vertex(boxSize, boxSize, 0);
    vertex(0, boxSize, 0);
    endShape();
  }

private void drawPlayer() {
  pushMatrix();

  // Positionner au centre de la case du joueur
  translate(playerX * boxSize + boxSize / 2,
            playerY * boxSize + boxSize / 2,
            boxSize / 2);

  float angle = 0; // vers le haut
  
  if (dirX == 1) {
    angle = -HALF_PI; // vers la droite
  } else if (dirX == -1) {
    angle = HALF_PI; // vers la gauche
  } else if (dirY == -1) {
    angle = PI; // vers le bas
  }

  rotate(angle);

  // Effet de pulsation pour la flèche : https://stackoverflow.com/questions/37691201/how-can-one-create-a-pulse-effect-in-processing
  float pulseSize = boxSize / 3 + sin(frameCount * 0.1) * boxSize / 20;

  // Dessiner la flèche
  stroke(64, 224, 208);  // Couleur turquoise
  strokeWeight(4);  // Épaisseur de la flèche
  fill(64, 224, 208, 200);  // Remplissage semi-transparent

  // Dessiner la pointe de la flèche
  beginShape();
  vertex(0, -pulseSize / 2); // Pointe de la flèche
  vertex(-boxSize / 6, pulseSize / 2); // Côté gauche
  vertex(boxSize / 6, pulseSize / 2); // Côté droit
  endShape(CLOSE);

  // Dessiner la tige de la flèche
  rect(0, pulseSize / 2, boxSize / 8, pulseSize);

  // Dessiner les plumes de la flèche
  line(-boxSize / 10, pulseSize, 0, pulseSize + boxSize / 8);
  line(boxSize / 10, pulseSize, 0, pulseSize + boxSize / 8);

  popMatrix();
}



  
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
  
  public void updatePlayerPosition(int positionX, int positionY) {
    boolean update = false;
    
    if (this.playerX != positionX) {
      this.playerX = positionX;
      update = true;
    }
    
    if (this.playerY != positionY) {
      this.playerY = positionY;
      update = true;
    }
    
    if (update) {
      updateDiscoveredArea();
    }
  }
}
