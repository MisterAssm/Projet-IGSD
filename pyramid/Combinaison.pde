// Variables pour le sable
Sable sable;
// Variables pour la pyramide
Pyramide pyramide;
PImage texturePierre;


void setup() {
  size(1000, 700, P3D);
  
  // Initialiser le sable
  sable = new Sable(200, 5, 40, 20.0);
  
  // Initialiser la pyramide
  texturePierre = loadImage("stonne.jpg");
  
  int tailleBase = 21;
  int nbEtages = 9;
  float tailleCellule = 40;
  float hauteurNiveau = 60;
  pyramide = new Pyramide(tailleBase, nbEtages, tailleCellule, hauteurNiveau, texturePierre);
}

void draw() {
  // Dessiner le sable en premier (fond)
  sable.dessinerSable();
  
 


  
  // Dessiner la pyramide positionnée en haut à droite
  pushMatrix();
  // Positionner la pyramide en haut à droite
  translate(width,height/2+110, -700);
  rotateX(PI/2);
  rotateZ(PI/3);
  
  pyramide.dessiner();
  popMatrix();
}
