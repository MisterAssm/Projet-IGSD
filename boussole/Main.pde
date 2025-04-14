Compass compass;

void setup() {
  size(800, 600, P3D);
  smooth();
  compass = new Compass(1);
}

void draw() {
  background(200);
  lights();
  compass.drawCompass();
}

void keyPressed() {
  compass.rotateToNextDirection();
}
