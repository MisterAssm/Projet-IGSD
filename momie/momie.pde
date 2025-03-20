PShape momie;

void setup() {
  size(500, 800, P3D);
  frameRate(20);
  
  momie = createShape(GROUP);
  PShape corps = creerCorpsMomie();
  PShape yeux = creerYeuxMomie();
  PShape bras = creerBrasMomie();
  
  momie.addChild(corps);
  momie.addChild(yeux);
  momie.addChild(bras);
}

void draw() {
  background(192);
  
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1);
  
  translate(width / 2, height / 2);
  rotateY(frameCount * 0.02);
  //rotateY(0.02);
  
  shape(momie);
}

PShape creerCorpsMomie() {
  PShape corps = createShape();
  corps.beginShape(QUAD_STRIP);
  
  int tours = 100;
  float hauteur = 300;
  float baseRadius = 50;
  float bandeLargeur = 10;
  
  for (int i = 0; i < tours; i++) {
    float angle = map(i, 0, tours, 0, TWO_PI * 10);
    float y = map(i, 0, tours, -hauteur / 2, hauteur / 2);
    float radius = baseRadius + noise(i * 0.1) * 20;
    
    for (int j = 0; j < 2; j++) {
      float a = angle + j * PI / 10;
      float x = radius * cos(a);
      float z = radius * sin(a);
      corps.fill(200 + noise(i * 0.1) * 55, 180 + noise(i * 0.1) * 30, 150);
      corps.vertex(x, y, z);
    }
  }
  
  corps.endShape();
  return corps;
}

PShape creerYeuxMomie() {
  PShape yeux = createShape(GROUP);
  for (int i = -1; i <= 1; i += 2) {
    PShape oeil = createShape(SPHERE, 10);
    oeil.translate(i * 20, -100, 40);
    oeil.setFill(color(255));
    yeux.addChild(oeil);
  }
  return yeux;
}

PShape creerBrasMomie() {
  PShape bras = createShape(GROUP);

  for (int i = -1; i <= 1; i += 2) {
    PShape brasSpiral = createShape();
    brasSpiral.beginShape(QUAD_STRIP);
    float longueur = 100;
    float baseRadius = 20;

    for (int j = 0; j < 40; j++) {
      float angle = j * TWO_PI * 3 / 40;
      float z = j * longueur / 40 - longueur / 2;
      float radius = baseRadius + noise(j * 0.1) * 5;

      for (int k = 0; k < 2; k++) {
        float a = angle + k * PI / 10;
        float x = radius * cos(a);
        float y = radius * sin(a);
        brasSpiral.fill(180 + noise(j * 0.1) * 50, 160 + noise(j * 0.1) * 40, 140);
        brasSpiral.vertex(x, y, z);
      }
    }

    brasSpiral.endShape();
    brasSpiral.translate(i * 70, -50, 40);
    brasSpiral.rotateY(TWO_PI * i); // Rotation autour de l'axe Y
    bras.addChild(brasSpiral);
  }
  return bras;
}
