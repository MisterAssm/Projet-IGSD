float da = PI / 50.; // angle pour la rotation
PShape momie;
PShape handModel;

void setup() {
  size(500, 700, P3D);
  frameRate(20);
  
  handModel = loadShape("hand1.obj");

  momie = createShape(GROUP);
  PShape corps = creerCorpsMomie();
  PShape tete = creerTeteMomie();
  PShape yeux = creerYeuxMomie();
  PShape bras = creerBrasMomie();

  momie.addChild(corps);
  momie.addChild(tete);
  momie.addChild(yeux);
  momie.addChild(bras);
}

void draw() {
  background(192);

  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  //directionalLight(204, 204, 204, -dirX, -dirY, -1);

  translate(width / 2, height / 2);
  rotateY(frameCount * 0.02);
  //rotateY(2.3);

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
        float noiseValue = 55 + 155 * noise(i / noiseScale); // augmenter min et diminuer max

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
        float noiseValue = 55 + 155 * noise(i / 11.f);
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

        PShape eye = createShape(SPHERE, 10);
        eye.scale(1.7, 1., 1.);
        eye.translate(xPosition, -280, 35);
        eye.setStroke(false);

        PShape eyeball = createShape(SPHERE, 3);
        eyeball.scale(1., 1.7, 1.);
        eyeball.translate(xPosition + i * 7, -280, 42);

        eyeball.setFill(color(0));

        eyes.addChild(eye);
        eyes.addChild(eyeball);
    }

    return eyes;
}

PShape creerBrasMomie() {
    PShape bras = createShape(GROUP);

    for (int direction = -1; direction <= 1; direction += 2) {
        PShape brasForme = createShape();
        brasForme.beginShape(QUAD_STRIP);
        brasForme.noStroke();
        brasForme.rotateX(PI / 2);

        for (int i = -100; i <= 100; i++) {
            float angleA = i / 20.0 * TWO_PI;
            float angleB = i / 30.0 * TWO_PI;
            float noiseValue = 55 + 155 * noise(i / 5.);

            float radiusVariation = 8 * cos(i * PI / 100.);
            float outerRadius = 20 + radiusVariation;
            float finalRadius = outerRadius + cos(angleB);

            brasForme.fill(noiseValue, noiseValue, 75);

            // Épaules plus volumineuses
            if (i < -50) {
                finalRadius *= 1.5;
            }
            // Coudes plus petits
            else if (i > -50 && i < 0) {
                finalRadius *= 0.7;
            }
            // Avant-bras plus volumineux
            else if (i > 0 && i < 50) {
                finalRadius *= 1.3;
            }

            brasForme.vertex(finalRadius * cos(angleA), finalRadius * sin(angleA), i);
            brasForme.vertex(finalRadius * cos(angleA + da), finalRadius * sin(angleA + da), i + 25);
        }

        brasForme.endShape(CLOSE);
        brasForme.rotateZ(-direction * PI / 3); // Rotation de ±90 degrés autour de l'axe Z
        brasForme.rotateY(-direction * PI / 4);
        brasForme.translate(direction * 80, -100, 50);
        bras.addChild(brasForme);
    }

    return bras;
}
