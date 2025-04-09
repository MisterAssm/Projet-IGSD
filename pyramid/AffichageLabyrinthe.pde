class AffichageLabyrinthe {
  private final Labyrinthe labyrinthe;
  
  int WALLD = 1;  // Niveau de détail des murs
  
  PShape labyShape;        // Forme pour les murs
  PShape floorShape;       // Forme pour le sol
  PShape ceilingShape;     // Forme pour les plafonds des corridors
  PShape wallCeilingShape; // Forme pour les plafonds des murs
  PImage texture;          // Texture des murs
  PImage textureSol;       // Texture du Sol 

  public AffichageLabyrinthe(PImage texture, Labyrinthe labyrinthe, PImage textureSol) {
    this.texture = texture;
    this.labyrinthe = labyrinthe;
    this.textureSol = textureSol;
    createShapes();
  }

private void createShapes() {
    float wallW = width/labyrinthe.getSize();
    float wallH = height/labyrinthe.getSize();

    // Réinitialiser toutes les shapes
    labyShape = createShape(GROUP);
    floorShape = createShape();
    ceilingShape = createShape();
    wallCeilingShape = createShape();

    // Configuration des shapes
    floorShape.beginShape(QUADS);
    floorShape.texture(textureSol);
    floorShape.noStroke();
    floorShape.textureMode(NORMAL);
    floorShape.fill(255);

    // Shape pour les plafonds
    ceilingShape.beginShape(QUADS);
    ceilingShape.noStroke();
    ceilingShape.fill(32);

    // Shape pour les plafonds des murs
    wallCeilingShape.beginShape(QUADS);
    wallCeilingShape.noStroke();
    wallCeilingShape.fill(32, 255, 0);

    // Parcours de la grille du labyrinthe
    for (int j = 0; j < labyrinthe.getSize(); j++) {
      for (int i = 0; i < labyrinthe.getSize(); i++) {
        if (labyrinthe.getLabyrinthe()[j][i] == '#') {
          PShape wall = createWallShape(i, j, wallW, wallH);
          labyShape.addChild(wall);

          wallCeilingShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
          wallCeilingShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
          wallCeilingShape.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
          wallCeilingShape.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);
        } else {
          // Nouvelle version corrigée pour le sol
          float tileSize = 0.2f; // Ajustez cette valeur pour changer l'échelle de la texture
          floorShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50, 
                           i*tileSize, j*tileSize);
          floorShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50, 
                           (i+1)*tileSize, j*tileSize);
          floorShape.vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50, 
                           (i+1)*tileSize, (j+1)*tileSize);
          floorShape.vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50, 
                           i*tileSize, (j+1)*tileSize);

          ceilingShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50);
          ceilingShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50);
          ceilingShape.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50);
          ceilingShape.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50);
        }
      }
    }

    floorShape.endShape();
    ceilingShape.endShape();
    wallCeilingShape.endShape();
}

  private PShape createWallShape(int i, int j, float wallW, float wallH) {
    PShape wall = createShape();
    wall.beginShape(QUADS);
    wall.texture(texture);
    wall.noStroke();
    wall.fill(i*25, j*25, 255-i*10+j*10);

    // Création des faces visibles seulement
    if (j == 0 || labyrinthe.getLabyrinthe()[j-1][i] == ' ') {
      wall.normal(0, -1, 0);
      createWallFace(wall, i, j, wallW, wallH, 0);
    }
    if (j == labyrinthe.getSize()-1 || labyrinthe.getLabyrinthe()[j+1][i] == ' ') {
      wall.normal(0, 1, 0);
      createWallFace(wall, i, j, wallW, wallH, 1);
    }
    if (i == 0 || labyrinthe.getLabyrinthe()[j][i-1] == ' ') {
      wall.normal(-1, 0, 0);
      createWallFace(wall, i, j, wallW, wallH, 2);
    }
    if (i == labyrinthe.getSize()-1 || labyrinthe.getLabyrinthe()[j][i+1] == ' ') {
      wall.normal(1, 0, 0);
      createWallFace(wall, i, j, wallW, wallH, 3);
    }

    wall.endShape();
    return wall;
  }

  private void createWallFace(PShape shape, int i, int j, float wallW, float wallH, int face) {
    for (int k = 0; k < WALLD; k++) {
      for (int l = -WALLD; l < WALLD; l++) {
        float bottomZ = (l+0)*50/WALLD;
        float topZ = (l+1)*50/WALLD;
        float sectionWidth = wallW/WALLD;
        float sectionHeight = wallH/WALLD;
        
        float u1 = k/(float)WALLD;
        float u2 = (k+1)/(float)WALLD;
        float v1 = (0.5+l/2.0/WALLD);
        float v2 = (0.5+(l+1)/2.0/WALLD);

        switch(face) {
          case 0: // Nord
            shape.vertex(i*wallW-wallW/2 + k*sectionWidth, j*wallH-wallH/2, bottomZ, u1*texture.width, v1*texture.height);
            shape.vertex(i*wallW-wallW/2 + (k+1)*sectionWidth, j*wallH-wallH/2, bottomZ, u2*texture.width, v1*texture.height);
            shape.vertex(i*wallW-wallW/2 + (k+1)*sectionWidth, j*wallH-wallH/2, topZ, u2*texture.width, v2*texture.height);
            shape.vertex(i*wallW-wallW/2 + k*sectionWidth, j*wallH-wallH/2, topZ, u1*texture.width, v2*texture.height);
            break;
            
          case 1: // Sud
            shape.vertex(i*wallW-wallW/2 + k*sectionWidth, j*wallH+wallH/2, topZ, u1*texture.width, v2*texture.height);
            shape.vertex(i*wallW-wallW/2 + (k+1)*sectionWidth, j*wallH+wallH/2, topZ, u2*texture.width, v2*texture.height);
            shape.vertex(i*wallW-wallW/2 + (k+1)*sectionWidth, j*wallH+wallH/2, bottomZ, u2*texture.width, v1*texture.height);
            shape.vertex(i*wallW-wallW/2 + k*sectionWidth, j*wallH+wallH/2, bottomZ, u1*texture.width, v1*texture.height);
            break;
            
          case 2: // Ouest
            shape.vertex(i*wallW-wallW/2, j*wallH-wallH/2 + k*sectionHeight, topZ, u1*texture.width, v2*texture.height);
            shape.vertex(i*wallW-wallW/2, j*wallH-wallH/2 + (k+1)*sectionHeight, topZ, u2*texture.width, v2*texture.height);
            shape.vertex(i*wallW-wallW/2, j*wallH-wallH/2 + (k+1)*sectionHeight, bottomZ, u2*texture.width, v1*texture.height);
            shape.vertex(i*wallW-wallW/2, j*wallH-wallH/2 + k*sectionHeight, bottomZ, u1*texture.width, v1*texture.height);
            break;
            
          case 3: // Est
            shape.vertex(i*wallW+wallW/2, j*wallH-wallH/2 + k*sectionHeight, bottomZ, u1*texture.width, v1*texture.height);
            shape.vertex(i*wallW+wallW/2, j*wallH-wallH/2 + (k+1)*sectionHeight, bottomZ, u2*texture.width, v1*texture.height);
            shape.vertex(i*wallW+wallW/2, j*wallH-wallH/2 + (k+1)*sectionHeight, topZ, u2*texture.width, v2*texture.height);
            shape.vertex(i*wallW+wallW/2, j*wallH-wallH/2 + k*sectionHeight, topZ, u1*texture.width, v2*texture.height);
            break;
        }
      }
    }
  }

  public void display(boolean inLab) {
    shape(floorShape, 0, 0);    // Dessine le sol en premier
    shape(labyShape, 0, 0);     // Puis les murs
    
    if (inLab) {
      shape(ceilingShape, 0, 0);
    } else {
      shape(wallCeilingShape, 0, 0);
    }
  }

  public void debugDraw() {
    float wallW = width/labyrinthe.getSize();
    float wallH = height/labyrinthe.getSize();
    
    for (int j = 0; j < labyrinthe.getSize(); j++) {
      for (int i = 0; i < labyrinthe.getSize(); i++) {
        if (labyrinthe.getLabyrinthe()[j][i] == '#') {
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
