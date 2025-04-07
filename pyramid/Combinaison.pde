/**
 * Exploration de Pyramide - Labyrinthe 3D
 * Programme permettant d'explorer un environnement 3D composé d'une pyramide 
 * avec plusieurs étages de labyrinthes à l'intérieur.
 */

// ==================== VARIABLES GLOBALES ====================

// === MODES D'AFFICHAGE ===
boolean vuealternative = false;  // Vue extérieure (désert) ou intérieure (labyrinthe)
boolean inLabyrinthe = false;    // Si le joueur est dans le labyrinthe de la pyramide

// === ÉLÉMENTS DE JEU ===
Sable sable;                     // Terrain désertique
ArrayList<Labyrinthe> labyrinthes = new ArrayList<>();  // Différents étages du labyrinthe
Labyrinthe lab;                  // Labyrinthe actuel
Minimap minimap;                 // Carte du labyrinthe pour navigation
int etageActuel = 0;             // Niveau actuel du labyrinthe
int[] taillesEtages = {21, 15, 11, 9, 7};  // Tailles des labyrinthes par étage

// === PYRAMIDES ===
Pyramide pyramidePrincipale;     // Pyramide principale
Pyramide pyramideSecondaire1;    // Pyramide secondaire 1
Pyramide pyramideSecondaire2;    // Pyramide secondaire 2

// === TEXTURES ===
PImage texturePierre;            // Texture pour les murs extérieurs
PImage textureSommet;            // Texture pour le sommet de la pyramide
PImage texturePorte;             // Texture pour la porte d'entrée
PImage textureMur;               // Texture pour les murs du labyrinthe

// === CAMÉRA EXTÉRIEURE ===
float camX = 0;                  // Position X de la caméra
float camY = 0;                  // Position Y de la caméra
float camZ = -600;               // Position Z de la caméra
float porteX = 0;                // Position X de la porte
float porteY = 0;                // Position Y de la porte
float porteZ = 0;                // Position Z de la porte

// === POSITION ET MOUVEMENT DU JOUEUR ===
int iposX = 1;                   // Position initiale X
int iposY = 0;                   // Position initiale Y
int posX = iposX;                // Position actuelle X
int posY = iposY;                // Position actuelle Y
int dirX = 0;                    // Direction X (regard)
int dirY = 1;                    // Direction Y (regard)
int odirX = 0;                   // Ancienne direction X (pour animation)
int odirY = 1;                   // Ancienne direction Y (pour animation)

// === ANIMATION ===
int anim = 0;                    // Compteur d'animation
boolean animT = false;           // Animation de déplacement en cours
boolean animR = false;           // Animation de rotation en cours
boolean inLab = true;            // Vue dans le labyrinthe

// ==================== INITIALISATION ====================

void setup() {
  // Configuration de base
  pixelDensity(2);
  randomSeed(2);
  size(1000, 700, P3D);
  
  // Chargement des textures
  chargerTextures();
  
  // Paramètres pour les pyramides
  int tailleBase = 21;
  int nbEtages = 9;
  float tailleCellule = 40;
  float hauteurNiveau = 60;
  
  // Création du sable du désert
  sable = new Sable(200, 5, 40, 20.0);
  
  // Création des labyrinthes pour chaque étage
  creerLabyrinthes();
  
  // Sélection du premier labyrinthe
  lab = labyrinthes.get(0);
  
  // Création des pyramides
  pyramidePrincipale = new Pyramide(tailleBase, nbEtages, tailleCellule, hauteurNiveau, texturePierre, textureSommet, texturePorte);
  pyramideSecondaire1 = new Pyramide(21, 9, 40, 60, texturePierre, textureSommet, texturePorte);
  pyramideSecondaire2 = new Pyramide(25, 10, 40, 60, texturePierre, textureSommet, texturePorte);
  
  // Création de la minimap
  this.minimap = new Minimap(lab);
}

// ==================== FONCTIONS PRINCIPALES ====================

void draw() {
  if (inLabyrinthe) {
    dessinerLabyrinthe();
  } else {
    if (vuealternative) {
      dessinerVueExterieure();
    } else {
      dessinerVuePyramide();
    }
  }
}

// ==================== FONCTIONS DE CHARGEMENT ====================

/**
 * Charge toutes les textures nécessaires
 */
void chargerTextures() {
  texturePierre = loadImage("text.jpg");
  textureSommet = loadImage("cpt.jpg");
  texturePorte = loadImage("p.png");
  textureMur = loadImage("stones.jpg");
}

/**
 * Crée les différents labyrinthes pour chaque étage
 */
void creerLabyrinthes() {
  for (int taille : taillesEtages) {
    labyrinthes.add(new Labyrinthe(taille, textureMur)); 
  }
}

// ==================== FONCTIONS DE RENDU ====================

/**
 * Dessine la vue extérieure avec le désert et les pyramides
 */
void dessinerVueExterieure() {
  float scalePorte = calculerEchellePorte();
  
  background(190, 170, 255);
  translate(width / 2 + camX, height / 2 + 100 + camY, camZ);
  rotateX(PI / 2);
  
  // Rotation progressive jusqu'à une certaine limite
  float rotationZ = min(frameCount * 0.005, 3.2);
  rotateZ(rotationZ);
  
  // Dessiner le désert et les pyramides
  drawDesert(8000, 200, 0.02, 20);
  pyramidePrincipale.dessiner(scalePorte);
  
  // Dessiner les pyramides secondaires
  dessinerPyramidesSecondaires(scalePorte);
  
  // Vérifier si on est devant la porte
  verifierEntreePyramide();
}

/**
 * Dessine la vue avec la pyramide en haut à droite
 */
void dessinerVuePyramide() {
  float scalePorte = calculerEchellePorte();
  sable.dessinerSable();
  
  // Dessiner la pyramide positionnée en haut à droite
  pushMatrix();
  translate(width, height / 2 + 110, -700);
  rotateX(PI / 2);
  rotateZ(PI / 3);
  pyramidePrincipale.dessiner(scalePorte);
  popMatrix();
}

/**
 * Dessine l'intérieur du labyrinthe avec caméra subjective
 */
void dessinerLabyrinthe() {
  background(192);
  sphereDetail(6);
  if (anim > 0) anim--;

  // Configuration de la caméra et des lumières pour le labyrinthe
  setupLabyrintheCameraLights();
  
  // Afficher la minimap en haut à gauche
  pushMatrix();
  minimap.drawMinimap();
  popMatrix();  // Ajout du popMatrix manquant

  // Ajuster la perspective et la caméra selon l'animation
  ajusterCameraLabyrinthe();
  
  // Dessiner les murs du labyrinthe
  noStroke();
  lab.getAffichage().display(inLab);
  
  // Vérifier si le joueur a atteint la sortie
  verifierSortieEtage();
}

// ==================== FONCTIONS AUXILIAIRES DE RENDU ====================

/**
 * Dessine les pyramides secondaires dans la vue extérieure
 */
void dessinerPyramidesSecondaires(float scalePorte) {
  pushMatrix();
  translate(500, -600, -300);
  pyramideSecondaire1.dessiner(scalePorte);
  popMatrix();
  
  pushMatrix();
  translate(-500, -600, -300);
  pyramideSecondaire1.dessiner(scalePorte);
  popMatrix();
}

/**
 * Configure la caméra et les lumières pour le labyrinthe
 */
void setupLabyrintheCameraLights() {
  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), 
         width/2.0, height/2.0, 0, 0, 1, 0);
  noLights();
  stroke(0);
}

/**
 * Ajuste la caméra du labyrinthe selon l'animation en cours
 */
void ajusterCameraLabyrinthe() {
  stroke(0);
  if (inLab) {
    float wallW = width/lab.getSize();
    float wallH = height/lab.getSize();
    
    perspective(2*PI/3, float(width)/float(height), 1, 1000);
    
    if (animT) {
      // Animation de déplacement
      camera((posX-dirX*anim/20.0)*wallW, (posY-dirY*anim/20.0)*wallH, -15+2*sin(anim*PI/5.0), 
             (posX-dirX*anim/20.0+dirX)*wallW, (posY-dirY*anim/20.0+dirY)*wallH, -15+4*sin(anim*PI/5.0), 0, 0, -1);
    } else if (animR) {
      // Animation de rotation
      camera(posX*wallW, posY*wallH, -15, 
            (posX+(odirX*anim+dirX*(20-anim))/20.0)*wallW, (posY+(odirY*anim+dirY*(20-anim))/20.0)*wallH, -15-5*sin(anim*PI/20.0), 0, 0, -1);
    } else {
      // Vue normale
      camera(posX*wallW, posY*wallH, -15, 
             (posX+dirX)*wallW, (posY+dirY)*wallH, -15, 0, 0, -1);
    }
    lightFalloff(0.0, 0.01, 0.0001);
  } else {
    lightFalloff(0.0, 0.05, 0.0001);
  }
  
  // Ajouter une lumière à la position du joueur
  float wallW = width/lab.getSize();
  float wallH = height/lab.getSize();
  pointLight(255, 255, 255, posX*wallW, posY*wallH, 15);
}

// ==================== FONCTIONS DE CALCUL ====================

/**
 * Calcule l'échelle de la porte en fonction de la distance de la caméra
 */
float calculerEchellePorte() {
  float scalePorte = map(abs(camZ), 200, 800, 2.0, 0.5);
  return constrain(scalePorte, 0.5, 2.0);
}

/**
 * Vérifie si le joueur est assez proche pour entrer dans la pyramide
 */
void verifierEntreePyramide() {
  if (dist(camX, camY, camZ, porteX, porteY, porteZ) < 99) {
    inLabyrinthe = true;
  }
}

/**
 * Vérifie si le joueur a atteint la sortie de l'étage actuel
 */
void verifierSortieEtage() {
  if (posX == lab.getSize()-1 && posY == lab.getSize()-2) {
    etageActuel++;
    if (etageActuel < labyrinthes.size()) {
      // Passer à l'étage suivant
      passerEtageSuivant();
    } else {
      // Sortir de la pyramide
      inLabyrinthe = false;
    }
  }
}

/**
 * Passe au niveau suivant du labyrinthe
 */
void passerEtageSuivant() {
  lab = labyrinthes.get(etageActuel);
  minimap = new Minimap(lab);
  
  // Réinitialiser la position et la direction du joueur
  posX = 1; 
  posY = 0;
  dirX = 0; 
  dirY = 1;
  
  // Réinitialisation graphique
  resetMatrix();
  textureMode(NORMAL);
}

// ==================== GÉNÉRATION DU TERRAIN ====================

/**
 * Génère terrain désertique
 */
void drawDesert(float size, int resolution, float scale, float height) {
  noStroke();
  textureMode(NORMAL);
  fill(184, 134, 11);  // Couleur sable

  for (int z = 0; z < resolution; z++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x <= resolution; x++) {
      float xPos = map(x, 0, resolution, -size / 2, size / 2);
      float zPos = map(z, 0, resolution, -size / 2, size / 2);
      float zPos2 = map(z + 1, 0, resolution, -size / 2, size / 2);

      // Utilisation du bruit de Perlin pour la hauteur
      float h1 = noise((xPos + 1000) * scale, (zPos + 1000) * scale) * height;
      float h2 = noise((xPos + 1000) * scale, (zPos2 + 1000) * scale) * height;

      vertex(xPos, zPos, h1);
      vertex(xPos, zPos2, h2);
    }
    endShape();
  }
}

// ==================== GESTION DES ENTRÉES UTILISATEUR ====================

void keyPressed() {
  if (inLabyrinthe) {
    gererTouchesLabyrinthe();
  } else {
    gererTouchesExterieur();
  }
}

/**
 * Gère les touches pour la navigation dans le labyrinthe
 */
void gererTouchesLabyrinthe() {
  if (anim == 0) {
    if (keyCode == UP) {
      deplacerJoueurAvant();
    } else if (keyCode == DOWN) {
      deplacerJoueurArriere();
    } else if (keyCode == LEFT) {
      tournerJoueurGauche();
    } else if (keyCode == RIGHT) {
      tournerJoueurDroite();
    }
    
    minimap.performKeyPressed(true, posX, posY);
    System.out.printf("(x,y) = (%d,%d)\n", posX, posY);
  }
  
  minimap.updateDiscoveredArea();
}

/**
 * Gère les touches pour la navigation extérieure
 */
void gererTouchesExterieur() {
  if (key == 32) { // Barre d'espace pour changer de vue
    vuealternative = !vuealternative;
  }

  if (vuealternative) {
    if (key == CODED) {
      if (keyCode == UP) {
        camZ += 50;      // Avancer
      } else if (keyCode == DOWN) {
        camZ -= 50;      // Reculer
      } else if (keyCode == LEFT) {
        camX += 50;      // Gauche
      } else if (keyCode == RIGHT) {
        camX -= 50;      // Droite
      }
    }
  }
}

// ==================== FONCTIONS DE DÉPLACEMENT DU JOUEUR ====================

void deplacerJoueurAvant() {
  if (!lab.isWall(posX+dirX, posY+dirY)) {
    posX += dirX; 
    posY += dirY;
    anim = 20;
    animT = true;
    animR = false;
  }
}

void deplacerJoueurArriere() {
  if (!lab.isWall(posY-dirY, posX-dirX)) {
    posX -= dirX;
    posY -= dirY;
  }
}

void tournerJoueurGauche() {
  odirX = dirX;
  odirY = dirY;
  anim = 20;
  int tmp = dirX; 
  dirX = dirY; 
  dirY = -tmp;
  animT = false;
  animR = true;
}

void tournerJoueurDroite() {
  odirX = dirX;
  odirY = dirY;
  anim = 20;
  animT = false;
  animR = true;
  int tmp = dirX; 
  dirX = -dirY; 
  dirY = tmp;
}
