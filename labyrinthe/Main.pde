int LAB_SIZE = 21;
char labyrinthe[][];
char sides[][][];

boolean camoufle[][];
int BOX_SIZE;

// Position initiale du joueur
int playerX = 1;
int playerY = 0;

void setup() {
  frameRate(20);
  randomSeed(2);
  size(1000, 1000, P3D);

  GenerateurLabyrinthe generateur = new GenerateurLabyrinthe(LAB_SIZE);
  labyrinthe = generateur.getLabyrinthe();
  sides = generateur.getCotes();

  camoufle = new boolean[LAB_SIZE][LAB_SIZE];
  BOX_SIZE = (width / LAB_SIZE) - 5;

  generateur.afficherLabyrinthe();
}

void draw() {
  background(255);
  translate(BOX_SIZE, BOX_SIZE);

  // Couleurs des coins
  color topLeft = color(33, 28, 132); // Bleu
  color topRight = color(232, 63, 37);    // Rouge
  color bottomLeft = color(96, 181, 255);  // Cyan
  color bottomRight = color(248, 237, 140); // Jaune
  
    // Lumière pour un effet de brillance
  //pointLight(255, 255, 255, width/2, height/2, 500);

  for (int j = 0; j < LAB_SIZE; j++) {
    for (int i = 0; i < LAB_SIZE; i++) {
      pushMatrix();
      translate(j * BOX_SIZE, i * BOX_SIZE);
      beginShape(QUADS);

      if (labyrinthe[i][j] == '#') {
        // Calculer la couleur interpolée
        float horizAmount = map(j, 0, LAB_SIZE - 1, 0, 1);
        float vertAmount = map(i, 0, LAB_SIZE - 1, 0, 1);

        color topColor = lerpColor(topLeft, topRight, horizAmount);
        color bottomColor = lerpColor(bottomLeft, bottomRight, horizAmount);
        color c = lerpColor(topColor, bottomColor, vertAmount);

        fill(c);

        drawCube();
      } else {
        fill(58, 58, 58);

        vertex(0, 0, 0);
        vertex(BOX_SIZE, 0, 0);
        vertex(BOX_SIZE, BOX_SIZE, 0);
        vertex(0, BOX_SIZE, 0);
      }

      endShape();
      popMatrix();
    }
  }

  // Dessiner la sphère représentant le joueur
  drawPlayer();
}

void drawCube() {
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
}

void drawPlayer() {
  pushMatrix();
  // Centrer la sphère dans le cube
  translate(playerX * BOX_SIZE + BOX_SIZE / 2, playerY * BOX_SIZE + BOX_SIZE / 2, BOX_SIZE / 2);
  // Couleur turquoise pour un effet attrayant  
  fill(64, 224, 208, 200); // Turquoise avec une légère transparence
  // Supprimer le contour de la sphère
  noStroke();
  sphere(BOX_SIZE / 3);
  // Réactiver le contour pour le reste du dessin
  stroke(0);
  popMatrix();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && playerY > 0 && labyrinthe[playerY - 1][playerX] != '#') {
      playerY--;
    }
    if (keyCode == DOWN && playerY < LAB_SIZE - 1 && labyrinthe[playerY + 1][playerX] != '#') {
      playerY++;
    }
    if (keyCode == LEFT && playerX > 0 && labyrinthe[playerY][playerX - 1] != '#') {
      playerX--;
    }
    if (keyCode == RIGHT && playerX < LAB_SIZE - 1 && labyrinthe[playerY][playerX + 1] != '#') {
      playerX++;
    }
  }
}
