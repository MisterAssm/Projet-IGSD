
class Labyrinthe {
  int LAB_SIZE;
  char[][] labyrinthe;
  char[][][] sides;
  int WALLD = 1;
  
  PShape labyShape;
  PShape ceilingShape;
  PShape wallCeilingShape;
  PImage texture;
  
  public Labyrinthe(PImage tex,int LAB_SIZE) {
    texture = tex;
    this.LAB_SIZE=LAB_SIZE;
    labyrinthe = new char[LAB_SIZE][LAB_SIZE];
    sides = new char[LAB_SIZE][LAB_SIZE][4];
    generateLabyrinth();
    createShapes();
  }
  
  
 private void generateLabyrinth() {
    // Génération du labyrinthe
    int todig = 0;
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        sides[j][i][0] = 0;
        sides[j][i][1] = 0;
        sides[j][i][2] = 0;
        sides[j][i][3] = 0;
        if (j%2==1 && i%2==1) {
          labyrinthe[j][i] = '.';
          todig++;
        } else {
          labyrinthe[j][i] = '#';
        }
      }
    }
    
    int gx = 1;
    int gy = 1;
    while (todig>0) {
      int oldgx = gx;
      int oldgy = gy;
      int alea = floor(random(0, 4));
      if      (alea==0 && gx>1)          gx -= 2;
      else if (alea==1 && gy>1)          gy -= 2;
      else if (alea==2 && gx<LAB_SIZE-2) gx += 2;
      else if (alea==3 && gy<LAB_SIZE-2) gy += 2;

      if (labyrinthe[gy][gx] == '.') {
        todig--;
        labyrinthe[gy][gx] = ' ';
        labyrinthe[(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
      }
    }

    labyrinthe[0][1] = ' '; // entrée
    labyrinthe[LAB_SIZE-2][LAB_SIZE-1] = ' '; // sortie

    // Détection des côtés
    for (int j=1; j<LAB_SIZE-1; j++) {
      for (int i=1; i<LAB_SIZE-1; i++) {
        if (labyrinthe[j][i]==' ') {
          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]==' ' &&
            labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
            sides[j-1][i][0] = 1;
          if (labyrinthe[j-1][i]==' ' && labyrinthe[j+1][i]=='#' &&
            labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
            sides[j+1][i][3] = 1;
          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
            labyrinthe[j][i-1]==' ' && labyrinthe[j][i+1]=='#')
            sides[j][i+1][1] = 1;
          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
            labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]==' ')
            sides[j][i-1][2] = 1;
        }
      }
    }
  }
  
  
  
  private void createShapes() {
    float wallW = width/LAB_SIZE;
    float wallH = height/LAB_SIZE;

    ceilingShape = createShape();
    wallCeilingShape = createShape();
    
    wallCeilingShape.beginShape(QUADS);
    ceilingShape.beginShape(QUADS);
    
    labyShape = createShape();
    labyShape.beginShape(QUADS);
    labyShape.texture(texture);
    labyShape.noStroke();
    
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        if (labyrinthe[j][i]=='#') {
          labyShape.fill(i*25, j*25, 255-i*10+j*10);
          
          // Création des murs
          if (j==0 || labyrinthe[j-1][i]==' ') {
            labyShape.normal(0, -1, 0);
            createWallFace(i, j, wallW, wallH, 0);
          }
          if (j==LAB_SIZE-1 || labyrinthe[j+1][i]==' ') {
            labyShape.normal(0, 1, 0);
            createWallFace(i, j, wallW, wallH, 1);
          }
          if (i==0 || labyrinthe[j][i-1]==' ') {
            labyShape.normal(-1, 0, 0);
            createWallFace(i, j, wallW, wallH, 2);
          }
          if (i==LAB_SIZE-1 || labyrinthe[j][i+1]==' ') {
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
 
  
  
  public boolean isWall(int x, int y) {
    if (x < 0 || x >= LAB_SIZE || y < 0 || y >= LAB_SIZE) {
      return true;
    }
    return labyrinthe[y][x] == '#';
  }

  
  
  public void debugDraw() {
    float wallW = width/LAB_SIZE;
    float wallH = height/LAB_SIZE;
    
    for (int j=0; j<LAB_SIZE; j++) {
      for (int i=0; i<LAB_SIZE; i++) {
        if (labyrinthe[j][i]=='#') {
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
