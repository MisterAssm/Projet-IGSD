// variables pour le labyrinthe interieure 

Labyrinthe lab;

int iposX = 1;
int iposY = -1;
int posX = iposX;
int posY = iposY;
int dirX = 0;
int dirY = 1;
int odirX = 0;
int odirY = 1;
int anim = 0;
boolean animT = false;
boolean animR = false;
boolean inLab = true;
boolean inLabyrinthe=false;

// Variables pour le sable
Sable sable;

// Variables pour la pyramide
Pyramide pyramide;
Pyramide pyramide1;
Pyramide pyramide2;
//images
PImage texturePierre;
PImage textureSommet;
PImage texturePorte;
PImage textureMur;
// Variables caméra en hors de la pyramide - deplacer a l exterieur de la pyrimide-
boolean vuealternative = false;
float camX = 0;
float camY = 0;
float camZ = -600;
float porteX = 0; // Position X de la porte
float porteY = 0; // Position Y de la porte
float porteZ = 0; // Position Z de la porte

int etageActuel=0;
int[] taillesEtages ={21,15,11,9,7};
ArrayList<Labyrinthe> labyrinthes = new ArrayList<>();



void setup() {
  //size(800, 800, P3D);
  
  pixelDensity(2);
  randomSeed(2);
  size(1000, 700, P3D);
  
  texturePierre = loadImage("text.jpg");
  textureSommet = loadImage("cpt.jpg");
  texturePorte = loadImage("p.png");
  textureMur = loadImage("stones.jpg");
  
  int tailleBase = 21;
  int nbEtages = 9;
  float tailleCellule = 40;
  float hauteurNiveau = 60;
  
  sable = new Sable(200, 5, 40, 20.0);
  //lab = new Labyrinthe(textureMur, taillesEtages[etageActuel]);
  
    for (int taille : taillesEtages) {
    labyrinthes.add(new Labyrinthe(textureMur, taille)); 
  }
  
  lab= labyrinthes.get(0);
  pyramide = new Pyramide(tailleBase, nbEtages, tailleCellule, hauteurNiveau, texturePierre, textureSommet, texturePorte);
  pyramide1 = new Pyramide(21, 9, 40, 60, texturePierre, textureSommet, texturePorte);
  pyramide2 = new Pyramide(25, 10, 40, 60, texturePierre, textureSommet, texturePorte);
  
  

 
}

void draw() {
  
  
  float scalePorte = map(abs(camZ), 200, 800, 2.0, 0.5);
  scalePorte = constrain(scalePorte, 0.5, 2.0);
    
  if (vuealternative) {
    background(190, 170, 255);
    translate(width / 2 + camX, height / 2 + 100 + camY, camZ);
    rotateX(PI / 2);
    if (frameCount * 0.005<3.2) rotateZ(frameCount * 0.005);
    else rotateZ(3.2);
    drawDesert(8000, 200, 0.02, 20);
    pyramide.dessiner(scalePorte);
    pushMatrix();
    translate(500, -600, -300);
    pyramide1.dessiner(scalePorte);
    popMatrix();
    pushMatrix();
    translate(-500, -600, -300);
    pyramide1.dessiner(scalePorte);
    popMatrix();  
    
    // Vérifier si on est devant la porte
    if (dist(camX, camY, camZ, porteX, porteY, porteZ) < 99) {
      inLabyrinthe = true;
    }
  }
  else {
    sable.dessinerSable();
    // Dessiner la pyramide positionnée en haut à droite
    pushMatrix();
    // Positionner la pyramide en haut à droite
    translate(width, height / 2 + 110, -700);
    rotateX(PI / 2);
    rotateZ(PI / 3);
    pyramide.dessiner(scalePorte);
    popMatrix();
  }
  
  
  if (inLabyrinthe) {
  background(192);
  sphereDetail(6);
  if (anim > 0) anim--;

  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  noLights();
  stroke(0);
  
  lab.debugDraw();
  
  pushMatrix();
  fill(0, 255, 0);
  noStroke();
  float wallW = width/lab.LAB_SIZE;
  float wallH = height/lab.LAB_SIZE;
  translate(50+posX*wallW/8, 50+posY*wallH/8, 50);
  sphere(3);
  popMatrix();

  stroke(0);
  if (inLab) {
    perspective(2*PI/3, float(width)/float(height), 1, 1000);
    if (animT) {
      camera((posX-dirX*anim/20.0)*wallW, (posY-dirY*anim/20.0)*wallH, -15+2*sin(anim*PI/5.0), 
             (posX-dirX*anim/20.0+dirX)*wallW, (posY-dirY*anim/20.0+dirY)*wallH, -15+4*sin(anim*PI/5.0), 0, 0, -1);
    } else if (animR) {
      camera(posX*wallW, posY*wallH, -15, 
            (posX+(odirX*anim+dirX*(20-anim))/20.0)*wallW, (posY+(odirY*anim+dirY*(20-anim))/20.0)*wallH, -15-5*sin(anim*PI/20.0), 0, 0, -1);
    } else {
      camera(posX*wallW, posY*wallH, -15, 
             (posX+dirX)*wallW, (posY+dirY)*wallH, -15, 0, 0, -1);
    }
    lightFalloff(0.0, 0.01, 0.0001);
  } else {
    lightFalloff(0.0, 0.05, 0.0001);
  }
  pointLight(255, 255, 255, posX*wallW, posY*wallH, 15);

  noStroke();
  lab.display(inLab);
  
  //-----------------------------------------------------------------


  // Vérifier si le joueur a atteint la sortie
   if (posX == lab.LAB_SIZE-1 && posY == lab.LAB_SIZE-2) {
    etageActuel++;
    if (etageActuel < labyrinthes.size()) {
      lab = labyrinthes.get(etageActuel);
      posX = 1; 
      posY = 0;
      dirX = 0; 
      dirY = 1;
      
      // Réinitialisation graphique profonde
      resetMatrix();
      textureMode(NORMAL);
    } else {
      inLabyrinthe = false;
    }
  }
  
  
  
    return;
  }
  

}



void drawDesert(float size, int resolution, float scale, float height) {
  noStroke();
  textureMode(NORMAL);
  fill(184, 134, 11);

  for (int z = 0; z < resolution; z++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x <= resolution; x++) {
      float xPos = map(x, 0, resolution, -size / 2, size / 2);
      float zPos = map(z, 0, resolution, -size / 2, size / 2);
      float zPos2 = map(z + 1, 0, resolution, -size / 2, size / 2);

      float h1 = noise((xPos + 1000) * scale, (zPos + 1000) * scale) * height;
      float h2 = noise((xPos + 1000) * scale, (zPos2 + 1000) * scale) * height;

      vertex(xPos, zPos, h1);
      vertex(xPos, zPos2, h2);
    }
    endShape();
  }
}

void keyPressed() {
  if (inLabyrinthe) {
   
 
  if (anim == 0) {
    if (keyCode == UP) {
      if (!lab.isWall(posX+dirX, posY+dirY)) {
        posX += dirX; 
        posY += dirY;
        anim = 20;
        animT = true;
        animR = false;
      }
    } else if (keyCode == DOWN && !lab.isWall(posY-dirY, posX-dirX)) {
      posX -= dirX; 
      posY -= dirY;
    } else if (keyCode == LEFT) {
      odirX = dirX;
      odirY = dirY;
      anim = 20;
      int tmp = dirX; 
      dirX = dirY; 
      dirY = -tmp;
      animT = false;
      animR = true;
    } else if (keyCode == RIGHT) {
      odirX = dirX;
      odirY = dirY;
      anim = 20;
      animT = false;
      animR = true;
      int tmp = dirX; 
      dirX = -dirY; 
      dirY = tmp;
    }
  }
  
    return;
  }
   
  if (key == 32) {
    vuealternative = !vuealternative;
  }

  if (vuealternative) {
    if (key == CODED) {
      if (keyCode == UP) {
        camZ += 50; // Move forward
      } else if (keyCode == DOWN) {
        camZ -= 50; // Move backward
      } else if (keyCode == LEFT) {
        camX += 50; // Move left
      } else if (keyCode == RIGHT) {
        camX -= 50; // Move right
      }
    }
  }
}
