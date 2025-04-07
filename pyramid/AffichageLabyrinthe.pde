class AffichageLabyrinthe {
  private final Labyrinthe labyrinthe;
  
  int WALLD = 1;
  
  PShape labyShape;
  PShape ceilingShape;
  PShape wallCeilingShape;
  PImage texture;
  
  public AffichageLabyrinthe(PImage texture, Labyrinthe labyrinthe) {
    this.texture = texture;
    
    this.labyrinthe = labyrinthe;
    
    createShapes();
  }
  
  
  private void createShapes() {
    float wallW = width/labyrinthe.getSize();
    float wallH = height/labyrinthe.getSize();

    ceilingShape = createShape();
    wallCeilingShape = createShape();
    
    wallCeilingShape.beginShape(QUADS);
    ceilingShape.beginShape(QUADS);
    
    labyShape = createShape();
    labyShape.beginShape(QUADS);
    labyShape.texture(texture);
    labyShape.noStroke();
    
    for (int j=0; j<labyrinthe.getSize(); j++) {
      for (int i=0; i<labyrinthe.getSize(); i++) {
        if (labyrinthe.getLabyrinthe()[j][i]=='#') {
          labyShape.fill(i*25, j*25, 255-i*10+j*10);
          
          // Création des murs
          if (j==0 || labyrinthe.getLabyrinthe()[j-1][i]==' ') {
            labyShape.normal(0, -1, 0);
            createWallFace(i, j, wallW, wallH, 0);
          }
          if (j==labyrinthe.getSize()-1 || labyrinthe.getLabyrinthe()[j+1][i]==' ') {
            labyShape.normal(0, 1, 0);
            createWallFace(i, j, wallW, wallH, 1);
          }
          if (i==0 || labyrinthe.getLabyrinthe()[j][i-1]==' ') {
            labyShape.normal(-1, 0, 0);
            createWallFace(i, j, wallW, wallH, 2);
          }
          if (i==labyrinthe.getSize()-1 || labyrinthe.getLabyrinthe()[j][i+1]==' ') {
            labyShape.normal(1, 0, 0);
            createWallFace(i, j, wallW, wallH, 3);
          }
          
          // Plafond pour les murs
          wallCeilingShape.fill(32, 255, 0);
          wallCeilingShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
          wallCeilingShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
          wallCeilingShape.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
          wallCeilingShape.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);        
        } else {
          // Sol
          labyShape.fill(192);
          labyShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50, 0, 0);
          labyShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50, 0, 1);
          labyShape.vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50, 1, 1);
          labyShape.vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50, 1, 0);
          
          // Plafond pour les chemins
          ceilingShape.fill(32);
          ceilingShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
          ceilingShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
          ceilingShape.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
          ceilingShape.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);
        }
      }
    }
    
    labyShape.endShape();
    ceilingShape.endShape();
    wallCeilingShape.endShape();
  }
  
  
  
  private void createWallFace(int i, int j, float wallW, float wallH, int face) {
    for (int k=0; k<WALLD; k++) {
      for (int l=-WALLD; l<WALLD; l++) {
        switch(face) {
          case 0: // Nord
            labyShape.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, k/(float)WALLD*texture.width, (0.5+l/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+l/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, k/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            break;
          case 1: // Sud
            labyShape.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, (k+0)/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+(l+0)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, (k+0)/(float)WALLD*texture.width, (0.5+(l+0)/2.0/WALLD)*texture.height);
            break;
          case 2: // Ouest
            labyShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, (k+0)/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+(l+0)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, (k+0)/(float)WALLD*texture.width, (0.5+(l+0)/2.0/WALLD)*texture.height);
            break;
          case 3: // Est
            labyShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, (k+0)/(float)WALLD*texture.width, (0.5+(l+0)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+(l+0)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, (k+1)/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            labyShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, (k+0)/(float)WALLD*texture.width, (0.5+(l+1)/2.0/WALLD)*texture.height);
            break;
        }
      }
    }
  }
  
  
  
  public void display(boolean inLab) {
    shape(labyShape, 0, 0);
    if (inLab) {
      shape(ceilingShape, 0, 0);
    } else {
      shape(wallCeilingShape, 0, 0);
    }
  }
  
  public void debugDraw() {
    float wallW = width/labyrinthe.getSize();
    float wallH = height/labyrinthe.getSize();
    
    for (int j=0; j<labyrinthe.getSize(); j++) {
      for (int i=0; i<labyrinthe.getSize(); i++) {
        if (labyrinthe.getLabyrinthe()[j][i]=='#') {
          fill(i*25, j*25, 255-i*10+j*10);
          pushMatrix();
          translate(50+i*wallW/8, 50+j*wallH/8, 50);
          box(wallW/10, wallH/10, 5);
          popMatrix();
        }
      }
    }
  }
}
