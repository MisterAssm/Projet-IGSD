int LAB_SIZE = 21;
char labyrinthe[][];
char sides[][][];

// Tableau pour suivre les cases découvertes
boolean discovered[][];
int viewDistance = 3; // Distance de visibilité autour du joueur

int BOX_SIZE;

// Position initiale du joueur
int playerX = 1;
int playerY = 0;

// Variables pour le contrôle de la caméra
float cameraRotX = 0;
float cameraRotY = 0;
float zoom = 1.0;

PShader shader;

void setup() {
  frameRate(30);
  randomSeed(2);
  size(1000, 1000, P3D);
  
  // Initialiser le shader
  shader = loadShader("LabyColor.glsl", "LabyTexture.glsl");
  
  GenerateurLabyrinthe generateur = new GenerateurLabyrinthe(LAB_SIZE);
  labyrinthe = generateur.getLabyrinthe();
  sides = generateur.getCotes();

  BOX_SIZE = (width / LAB_SIZE) - 5;
  
  discovered = new boolean[LAB_SIZE][LAB_SIZE];
  
  // Marquer position initiale et ses environs comme découverts
  updateDiscoveredArea();
}

void draw() {
  background(20);
  
  // Configurer les lumières
  ambientLight(60, 60, 60);
  directionalLight(200, 200, 200, 0, 0, -1);
  pointLight(150, 150, 150, playerX * BOX_SIZE + BOX_SIZE/2, playerY * BOX_SIZE + BOX_SIZE/2, BOX_SIZE*2);
  
  shader(shader);
  
  // Configuration de la caméra
  translate(width/2, height/2);
  rotateX(cameraRotX);
  rotateY(cameraRotY);
  scale(zoom);
  translate(-BOX_SIZE * (LAB_SIZE/2), -BOX_SIZE * (LAB_SIZE/2), 0);
  
  // Couleurs des coins pour le dégradé
  color topLeft = color(33, 28, 132); // Bleu
  color topRight = color(232, 63, 37);    // Rouge
  color bottomLeft = color(96, 181, 255);  // Cyan
  color bottomRight = color(248, 237, 140); // Jaune

  // Dessiner le labyrinthe
  for (int j = 0; j < LAB_SIZE; j++) {
    for (int i = 0; i < LAB_SIZE; i++) {
      pushMatrix();
      translate(j * BOX_SIZE, i * BOX_SIZE, 0);
      
      // Dessiner que les cases découvertes
      if (discovered[i][j]) {
        if (labyrinthe[i][j] == '#') {
          // Calculer la couleur pour les murs
          float horizAmount = (float) j / (LAB_SIZE - 1);
          float vertAmount = (float) i / (LAB_SIZE - 1);

          color topColor = lerpColor(topLeft, topRight, horizAmount);
          color bottomColor = lerpColor(bottomLeft, bottomRight, horizAmount);
          color c = lerpColor(topColor, bottomColor, vertAmount);

          fill(c);
          noStroke();
          drawCube();
        } else {
          // Sol
          fill(58, 58, 58);
          beginShape(QUADS);
          vertex(0, 0, 0);
          vertex(BOX_SIZE, 0, 0);
          vertex(BOX_SIZE, BOX_SIZE, 0);
          vertex(0, BOX_SIZE, 0);
          endShape();
        }
      } else {
        // Cases non découvertes
        fill(10, 10, 10, 20);  // Presque invisible
        beginShape(QUADS);
        vertex(0, 0, 0);
        vertex(BOX_SIZE, 0, 0);
        vertex(BOX_SIZE, BOX_SIZE, 0);
        vertex(0, BOX_SIZE, 0);
        endShape();
      }
      
      popMatrix();
    }
  }

  drawPlayer();
  
  // Désactiver le shader (pour plus tard)
  resetShader();
}

void drawCube() {
  beginShape(QUADS);
  // Face avant
  vertex(0, 0, BOX_SIZE); // haut gauche
  vertex(BOX_SIZE, 0, BOX_SIZE); // haut droite
  vertex(BOX_SIZE, BOX_SIZE, BOX_SIZE); // bas droite
  vertex(0, BOX_SIZE, BOX_SIZE); // bas gauche

  // Face arrière
  vertex(0, 0, 0); // bas gauche
  vertex(BOX_SIZE, 0, 0); // bas droite
  vertex(BOX_SIZE, BOX_SIZE, 0); // haut droite
  vertex(0, BOX_SIZE, 0); // haut gauche

  // Face gauche
  vertex(0, 0, 0); // bas gauche
  vertex(0, 0, BOX_SIZE); // haut gauche
  vertex(0, BOX_SIZE, BOX_SIZE); // haut droite
  vertex(0, BOX_SIZE, 0); // bas droite

  // Face droite
  vertex(BOX_SIZE, 0, 0); // bas gauche
  vertex(BOX_SIZE, 0, BOX_SIZE); // haut gauche
  vertex(BOX_SIZE, BOX_SIZE, BOX_SIZE); // haut droite
  vertex(BOX_SIZE, BOX_SIZE, 0); // bas droite

  // Face inférieure
  vertex(0, 0, 0); // bas gauche
  vertex(BOX_SIZE, 0, 0); // bas droite
  vertex(BOX_SIZE, 0, BOX_SIZE); // haut droite
  vertex(0, 0, BOX_SIZE); // haut gauche

  // Face supérieure
  vertex(0, BOX_SIZE, 0); // bas gauche
  vertex(BOX_SIZE, BOX_SIZE, 0); // bas droite
  vertex(BOX_SIZE, BOX_SIZE, BOX_SIZE); // haut droite
  vertex(0, BOX_SIZE, BOX_SIZE); // haut gauche
  endShape();
}

void drawPlayer() {
  pushMatrix();
  // position du joueur
  translate(playerX * BOX_SIZE + BOX_SIZE / 2, playerY * BOX_SIZE + BOX_SIZE / 2, BOX_SIZE / 2);
  
  // Effet de pulsation pour le joueur : https://stackoverflow.com/questions/37691201/how-can-one-create-a-pulse-effect-in-processing
  float pulseSize = BOX_SIZE / 3 + sin(frameCount * 0.1) * BOX_SIZE / 20;
  
  fill(64, 224, 208, 200); // Turquoise avec une légère transparence
  emissive(20, 80, 80); // Lumière émise par le joueur
  noStroke();
  sphere(pulseSize);
  
  // Réinitialiser l'émissivité et réactiver le contour
  emissive(0, 0, 0);
  stroke(0);
  popMatrix();
}

void updateDiscoveredArea() {
  // Découvrir les cases autour
  for (int y = max(0, playerY - viewDistance); y <= min(LAB_SIZE - 1, playerY + viewDistance); y++) {
    for (int x = max(0, playerX - viewDistance); x <= min(LAB_SIZE - 1, playerX + viewDistance); x++) {
      // Calcul de la distance (Manhattan)
      int distance = abs(x - playerX) + abs(y - playerY);
      
      // Découvrir la case si elle est dans la distance de vue
      if (distance <= viewDistance) {
        discovered[y][x] = true;
      }
    }
  }
}

void keyPressed() {
  boolean moved = false;
  
  if (key == CODED) {
    if (keyCode == UP && playerY > 0 && labyrinthe[playerY - 1][playerX] != '#') {
      playerY--;
      moved = true;
    }
    if (keyCode == DOWN && playerY < LAB_SIZE - 1 && labyrinthe[playerY + 1][playerX] != '#') {
      playerY++;
      moved = true;
    }
    if (keyCode == LEFT && playerX > 0 && labyrinthe[playerY][playerX - 1] != '#') {
      playerX--;
      moved = true;
    }
    if (keyCode == RIGHT && playerX < LAB_SIZE - 1 && labyrinthe[playerY][playerX + 1] != '#') {
      playerX++;
      moved = true;
    }
  } else {
    // Contrôles de la cam
    if (key == 'a' || key == 'A') {
      zoom *= 1.1; // Zoomer
    }
    if (key == 'e' || key == 'E') {
      zoom *= 0.9; // Dézoomer
    }
    if (key == 'q' || key == 'Q') {
      cameraRotY -= 0.1; // Rotation caméra
    }
    if (key == 'd' || key == 'D') {
      cameraRotY += 0.1;
    }
    if (key == 'z' || key == 'Z') {
      cameraRotX -= 0.1;
    }
    if (key == 's' || key == 'S') {
      cameraRotX += 0.1;
    }
  }
  
  // Maj zone découverte après déplacement
  if (moved) {
    updateDiscoveredArea();
  }
}
