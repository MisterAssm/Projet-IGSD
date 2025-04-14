Compass myCompass;

void setup() {
  size(800, 600, P3D);
  smooth();
  //textMode(SHAPE);
  myCompass = new Compass();
}

void draw() {
  background(200);
  lights();
  myCompass.drawCompass();
}

void keyPressed() {
  myCompass.rotateToNextDirection();
}
