class Compass {
  private int targetDirection = 0;
  private int currentDirection = 0;
  private float rotationProgress = 0;
  private boolean isRotating = false;
  private float rotationSpeed = 0.1;
  private PShape compassShape;
  private PGraphics cardinalTexts;
  
  public Compass() {
    // Créer les textes cardinaux
    createCardinalTexts();
    
    // Créer la forme de la boussole
    compassShape = createCompassShape();
  }
  
  public void drawCompass() {
    // Dessin de la boussole
    pushMatrix();
    translate(width/2, height/2);
    rotateX(radians(45));
    
    hint(DISABLE_DEPTH_TEST);
    shape(compassShape);
    image(cardinalTexts, -cardinalTexts.width/2, -cardinalTexts.height/2);
    hint(ENABLE_DEPTH_TEST);
    
    drawAnimatedArrow();
    popMatrix();
    
    updateAnimation();
  }
  
  public void rotateToNextDirection() {
    if (!isRotating) {
      targetDirection = (currentDirection + 1) % 4;
      isRotating = true;
    }
  }
  
  private void createCardinalTexts() {
    cardinalTexts = createGraphics(400, 400);
    cardinalTexts.beginDraw();
    cardinalTexts.clear();
    cardinalTexts.textMode(SHAPE);
    cardinalTexts.textSize(28);
    cardinalTexts.textAlign(CENTER, CENTER);
    
    String[] points = {"N", "E", "S", "O"};
    for(int i = 0; i < 4; i++) {
      cardinalTexts.pushMatrix();
      cardinalTexts.translate(cardinalTexts.width/2, cardinalTexts.height/2);
      cardinalTexts.rotate(HALF_PI * i);
      cardinalTexts.translate(0, -120);
      
      cardinalTexts.fill(255, 200);
      cardinalTexts.noStroke();
      cardinalTexts.ellipse(0, 0, 40, 40);
      
      if (i == 0) {
        cardinalTexts.fill(232, 63, 37);
      } else {
        cardinalTexts.fill(0);
      }
      
      cardinalTexts.text(points[i], 0, 0);
      cardinalTexts.popMatrix();
    }
    cardinalTexts.endDraw();
  }
  
  private PShape createCompassShape() {
    PShape s = createShape(GROUP);
    
    // Base thickness
    for(int i = 0; i < 3; i++) {
      PShape layer = createShape(ELLIPSE, 0, 15 + i*10, 410, 410);
      layer.setFill(#d4b37a);
      layer.setStroke(false);
      s.addChild(layer);
    }
    
    // Main compass
    PShape mainCircle = createShape(ELLIPSE, 0, 0, 400, 400);
    mainCircle.setFill(#f9e1b6);
    mainCircle.setStroke(false);
    s.addChild(mainCircle);
    
    // Anneau intermédiaire
    PShape ring = createShape(ELLIPSE, 0, 0, 370, 370);
    ring.setFill(false);
    ring.setStroke(#dcbf8e);
    ring.setStrokeWeight(30);
    s.addChild(ring);
    
    // Cercle central
    PShape centerCircle = createShape(ELLIPSE, 0, 0, 100, 100);
    centerCircle.setFill(255);
    centerCircle.setStroke(false);
    s.addChild(centerCircle);
    
    // Decorative patterns
    PShape decor = createShape(GROUP);
    
    // Triangles
    for(int i = 0; i < 360; i += 30) {
      PShape tri = createShape();
      tri.beginShape(TRIANGLE);
      tri.fill(#a38b5a);
      tri.noStroke();
      
      if(i % 90 == 0) {
        tri.vertex(-8, 0);
        tri.vertex(8, 0);
        tri.vertex(0, 15);
      } else {
        tri.vertex(-4, 0);
        tri.vertex(4, 0);
        tri.vertex(0, 10);
      }
      tri.endShape();
      
      PShape positionedTri = createShape(GROUP);
      positionedTri.translate(0, -170);
      positionedTri.rotateZ(radians(i));
      positionedTri.addChild(tri);
      decor.addChild(positionedTri);
    }
    
    // Lignes radiales
    for(int i = 0; i < 360; i += 10) {
      PShape lineShape = createShape(LINE, 0, -120, 0, -140);
      lineShape.setStroke(#c0a87c);
      lineShape.setStrokeWeight(1.5);
      
      PShape positionedLine = createShape(GROUP);
      positionedLine.rotateZ(radians(i));
      positionedLine.addChild(lineShape);
      decor.addChild(positionedLine);
    }
    
    // Texture pointillée
    PShape dots = createShape(GROUP);
    for(int i = 0; i < 200; i++) {
      float angle = random(TWO_PI);
      float radius = random(140, 180);
      float x = cos(angle) * radius;
      float y = sin(angle) * radius;
      
      PShape dot = createShape(ELLIPSE, x, y, 2, 2);
      dot.setFill(#d4b37a);
      dot.setStroke(false);
      dots.addChild(dot);
    }
    decor.addChild(dots);
    s.addChild(decor);
    
    return s;
  }
  
  private void drawAnimatedArrow() {
    pushMatrix();
    translate(0, 0, 1);
    rotateZ(calculateCurrentAngle());
    
    // Flèche
    fill(#FF0000);
    noStroke();
    beginShape();
    vertex(-12, -80);
    vertex(0, -110);
    vertex(12, -80);
    vertex(0, -65);
    endShape(CLOSE);
    
    // Détail lumineux
    fill(255, 150);
    noStroke();
    beginShape();
    vertex(-6, -80);
    vertex(0, -105);
    vertex(6, -80);
    endShape(CLOSE);

    // Contour métallique
    stroke(255);
    strokeWeight(1.5);
    noFill();
    beginShape();
    vertex(-12, -80);
    vertex(0, -110);
    vertex(12, -80);
    endShape(CLOSE);
    popMatrix();
  }
  
  private float calculateCurrentAngle() {
    if (isRotating) {
      float startAngle = currentDirection * HALF_PI;
      float endAngle = targetDirection * HALF_PI;
      
      float diff = endAngle - startAngle;
      if (abs(diff) > PI) {
        endAngle += diff > 0 ? -TWO_PI : TWO_PI;
      }
      
      return lerp(startAngle, endAngle, rotationProgress);
    }
    return currentDirection * HALF_PI;
  }
  
  private void updateAnimation() {
    if (isRotating) {
      rotationProgress = min(rotationProgress + rotationSpeed, 1.0);
      if (rotationProgress == 1.0) {
        currentDirection = targetDirection;
        isRotating = false;
        rotationProgress = 0;
      }
    }
  }
}
