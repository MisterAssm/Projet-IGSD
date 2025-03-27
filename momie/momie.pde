float da = PI / 50.; // angle pour la rotation
PShape momie;

void setup() {
  size(500, 800, P3D);
  frameRate(20);
  
  momie = createShape(GROUP);
  PShape corps = creerCorpsMomie();
  PShape tete = creerTeteMomie();
  PShape yeux = creerYeuxMomie();
  //PShape bras = creerBrasMomie();
  
  momie.addChild(corps);
  momie.addChild(tete);
  momie.addChild(yeux);
  //momie.addChild(bras);
}

void draw() {
  background(192);
  
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  //directionalLight(204, 204, 204, -dirX, -dirY, -1);
  
  translate(width / 2, height / 2);
  rotateY(frameCount * 0.02);
  
  shape(momie);
}

// Quadstrip ressemblant plus à des bandages si possible (quadstrip en forme de rectangle)
PShape creerCorpsMomie() {
    float baseRadius = 60;
    float noiseScale = 5.; // variation de couleur
    float heightOffset = PI / 6.;
    int stepSize = 25; 
    
    PShape corps = createShape();
    corps.beginShape(QUAD_STRIP);
    corps.noStroke();
    corps.rotateX(PI / 2); // rotation pour aligner correctement la forme
    
    for (int i = -200; i <= 200; i++) {
        float angleA = i / 20.0 * TWO_PI; 
        float angleB = i / 30.0 * TWO_PI; 
        float heightGap = 3 + cos(heightOffset);
        float noiseValue = 100 + 110 * noise(i / noiseScale); // augmenter min et diminuer max
        
        corps.fill(noiseValue, noiseValue, 75);
        
        float radiusVariation = 8 * cos(i * PI / 200.); 
        float outerRadius = baseRadius + radiusVariation;
        float finalRadius = outerRadius + cos(angleB);
        
        corps.vertex(finalRadius * cos(angleA), finalRadius * sin(angleA), heightGap + i); // Premier sommet
        
        radiusVariation = 8 * cos((i + stepSize) * PI / 200.); // second sommet
        outerRadius = baseRadius + radiusVariation;
        finalRadius = outerRadius + cos(angleB);
        
        corps.vertex(finalRadius * cos(angleA + da), finalRadius * sin(angleA + da), heightGap + (i + stepSize)); // second sommet
    }
    
    corps.endShape(CLOSE);
    return corps;
}

PShape creerTeteMomie() {
    PShape head = createShape();
    head.beginShape(QUAD_STRIP);
    head.noStroke();
    head.rotateX(PI / 2);

    // Dessiner la tête en utilisant une bande de quads
    for (int i = -100; i <= 90; i++) {
        float angle1 = i / 22.0f * TWO_PI;
        float angle2 = i / 32.0f * TWO_PI;
        float noiseValue = 25 + 185 * noise(i / 11.f);
        float depth = 255 + cos(28.0f);

        head.fill(noiseValue, noiseValue, 55);

        // rayons pour les sommets
        float radius2 = 16 + 34 * cos(i * PI / 195) + cos(angle2);

        // Ajouter les sommets à la forme
        head.vertex(radius2 * cos(angle1), radius2 * sin(angle1), depth + i);

        radius2 = 15 + 35 * cos((i + 25) * PI / 195) + cos(angle2);

        head.vertex(radius2 * cos(angle1 + da), radius2 * sin(angle1 + da), depth + i + 24);
    }

    head.endShape(CLOSE);
    return head;
}

// Suggestion prof : un PShape pour l'oeil et l'autre pour la pupille
PShape creerYeuxMomie() {
    PShape eyes = createShape(GROUP);

    for (int i = -1; i <= 1; i += 2) {
        float xPosition = i * 16;

        // createShape(ELLIPSE, 0, 0, 10, 15); ????????? NE FONCTIONNE PAS
        PShape eye = createShape(SPHERE, 10);
        eye.translate(xPosition, -280, 40);
        
        //PShape eye = createShape(ELLIPSE, 0, 0, 20, 15);
        //eye.translate(xPosition, -280, 45);
        
        eye.setStroke(false);

        PShape eyeball = createShape(SPHERE, 5);
        eyeball.translate(xPosition, -280, 45);
        
        //PShape eyeball = createShape(ELLIPSE, 0, 0, 5, 10);
        //eyeball.translate(xPosition, -280, 50);
        
        eyeball.setFill(color(0));

        eyes.addChild(eye);
        eyes.addChild(eyeball);
    }

    return eyes;
}

// TODO: à refaire
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
    brasSpiral.rotateY(TWO_PI * i);
    bras.addChild(brasSpiral);
  }
  return bras;
}
