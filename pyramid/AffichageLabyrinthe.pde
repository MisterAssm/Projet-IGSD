/**
 * Classe gérant l'affichage graphique du labyrinthe en 3D
 * Corrige le problème où les murs prennent un carré et demi et assure l'affichage correct des textures
 */
class AffichageLabyrinthe {
  private final Labyrinthe labyrinthe;
  
  int WALLD = 1;  // Niveau de détail des murs
  
  PShape labyShape;        // Forme pour les murs et sols
  PShape ceilingShape;     // Forme pour les plafonds des corridors
  PShape wallCeilingShape; // Forme pour les plafonds des murs
  PImage texture;          // Texture des murs
  
  /**
   * Constructeur pour AffichageLabyrinthe
   * @param texture Texture à appliquer aux murs
   * @param labyrinthe Objet Labyrinthe à afficher
   */
  public AffichageLabyrinthe(PImage texture, Labyrinthe labyrinthe) {
    this.texture = texture;
    this.labyrinthe = labyrinthe;
    createShapes();
  }
  
  /**
   * Crée les formes 3D (PShape) pour le labyrinthe
   */
  private void createShapes() {
    float wallW = width/labyrinthe.getSize();
    float wallH = height/labyrinthe.getSize();

    // Initialisation des shapes
    ceilingShape = createShape();
    wallCeilingShape = createShape();
    
    wallCeilingShape.beginShape(QUADS);
    ceilingShape.beginShape(QUADS);
    
    labyShape = createShape();
    labyShape.beginShape(QUADS);
    labyShape.texture(texture);
    labyShape.noStroke();
    
    // Parcours de la grille du labyrinthe
    for (int j=0; j<labyrinthe.getSize(); j++) {
      for (int i=0; i<labyrinthe.getSize(); i++) {
        if (labyrinthe.getLabyrinthe()[j][i]=='#') { // Si c'est un mur
          labyShape.fill(i*25, j*25, 255-i*10+j*10);
          
          // Création des murs seulement aux frontières (où il y a un espace à côté)
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
        } else { // Si c'est un espace vide
          // Sol
          labyShape.fill(192);
          labyShape.vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50, 0, 0);
          labyShape.vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50, 1, 0);
          labyShape.vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50, 1, 1);
          labyShape.vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50, 0, 1);
          
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
  
  /**
   * Crée une face de mur à la position spécifiée avec textures correctement appliquées
   * 
   * @param i Colonne dans la grille
   * @param j Ligne dans la grille
   * @param wallW Largeur d'une cellule
   * @param wallH Hauteur d'une cellule
   * @param face Direction de la face (0=Nord, 1=Sud, 2=Ouest, 3=Est)
   */
  private void createWallFace(int i, int j, float wallW, float wallH, int face) {
    for (int k=0; k<WALLD; k++) {
      for (int l=-WALLD; l<WALLD; l++) {
        // Variables pour les positions des vertices
        float x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4;
        // Variables pour les coordonnées de texture
        float u1, v1, u2, v2, u3, v3, u4, v4;
        
        // Calcul des hauteurs Z
        float bottomZ = (l+0)*50/WALLD;
        float topZ = (l+1)*50/WALLD;
        
        // Section dimensions
        float sectionWidth = wallW/WALLD;
        float sectionHeight = wallH/WALLD;
        
        // Coordonnées UV de base pour la texture (utilise les valeurs d'origine pour préserver l'aspect)
        u1 = k/(float)WALLD;
        u2 = (k+1)/(float)WALLD;
        v1 = (0.5+l/2.0/WALLD);
        v2 = (0.5+(l+1)/2.0/WALLD);
        
        switch(face) {
          case 0: // Nord
            // Coordonnées du quad
            x1 = i*wallW-wallW/2 + k*sectionWidth;
            y1 = j*wallH-wallH/2;
            z1 = bottomZ;
            
            x2 = i*wallW-wallW/2 + (k+1)*sectionWidth;
            y2 = j*wallH-wallH/2;
            z2 = bottomZ;
            
            x3 = i*wallW-wallW/2 + (k+1)*sectionWidth;
            y3 = j*wallH-wallH/2;
            z3 = topZ;
            
            x4 = i*wallW-wallW/2 + k*sectionWidth;
            y4 = j*wallH-wallH/2;
            z4 = topZ;
            
            // Dessiner le quad avec texture
            labyShape.vertex(x1, y1, z1, u1*texture.width, v1*texture.height);
            labyShape.vertex(x2, y2, z2, u2*texture.width, v1*texture.height);
            labyShape.vertex(x3, y3, z3, u2*texture.width, v2*texture.height);
            labyShape.vertex(x4, y4, z4, u1*texture.width, v2*texture.height);
            break;
            
          case 1: // Sud
            // Coordonnées du quad
            x1 = i*wallW-wallW/2 + k*sectionWidth;
            y1 = j*wallH+wallH/2;
            z1 = topZ;
            
            x2 = i*wallW-wallW/2 + (k+1)*sectionWidth;
            y2 = j*wallH+wallH/2;
            z2 = topZ;
            
            x3 = i*wallW-wallW/2 + (k+1)*sectionWidth;
            y3 = j*wallH+wallH/2;
            z3 = bottomZ;
            
            x4 = i*wallW-wallW/2 + k*sectionWidth;
            y4 = j*wallH+wallH/2;
            z4 = bottomZ;
            
            // Dessiner le quad avec texture
            labyShape.vertex(x1, y1, z1, u1*texture.width, v2*texture.height);
            labyShape.vertex(x2, y2, z2, u2*texture.width, v2*texture.height);
            labyShape.vertex(x3, y3, z3, u2*texture.width, v1*texture.height);
            labyShape.vertex(x4, y4, z4, u1*texture.width, v1*texture.height);
            break;
            
          case 2: // Ouest
            // Coordonnées du quad
            x1 = i*wallW-wallW/2;
            y1 = j*wallH-wallH/2 + k*sectionHeight;
            z1 = topZ;
            
            x2 = i*wallW-wallW/2;
            y2 = j*wallH-wallH/2 + (k+1)*sectionHeight;
            z2 = topZ;
            
            x3 = i*wallW-wallW/2;
            y3 = j*wallH-wallH/2 + (k+1)*sectionHeight;
            z3 = bottomZ;
            
            x4 = i*wallW-wallW/2;
            y4 = j*wallH-wallH/2 + k*sectionHeight;
            z4 = bottomZ;
            
            // Dessiner le quad avec texture
            labyShape.vertex(x1, y1, z1, u1*texture.width, v2*texture.height);
            labyShape.vertex(x2, y2, z2, u2*texture.width, v2*texture.height);
            labyShape.vertex(x3, y3, z3, u2*texture.width, v1*texture.height);
            labyShape.vertex(x4, y4, z4, u1*texture.width, v1*texture.height);
            break;
            
          case 3: // Est
            // Coordonnées du quad
            x1 = i*wallW+wallW/2;
            y1 = j*wallH-wallH/2 + k*sectionHeight;
            z1 = bottomZ;
            
            x2 = i*wallW+wallW/2;
            y2 = j*wallH-wallH/2 + (k+1)*sectionHeight;
            z2 = bottomZ;
            
            x3 = i*wallW+wallW/2;
            y3 = j*wallH-wallH/2 + (k+1)*sectionHeight;
            z3 = topZ;
            
            x4 = i*wallW+wallW/2;
            y4 = j*wallH-wallH/2 + k*sectionHeight;
            z4 = topZ;
            
            // Dessiner le quad avec texture
            labyShape.vertex(x1, y1, z1, u1*texture.width, v1*texture.height);
            labyShape.vertex(x2, y2, z2, u2*texture.width, v1*texture.height);
            labyShape.vertex(x3, y3, z3, u2*texture.width, v2*texture.height);
            labyShape.vertex(x4, y4, z4, u1*texture.width, v2*texture.height);
            break;
        }
      }
    }
  }
  
  /**
   * Affiche le labyrinthe avec ou sans plafond selon le mode
   * @param inLab Si true, affiche le plafond des corridors
   */
  public void display(boolean inLab) {
    shape(labyShape, 0, 0);
    if (inLab) {
      shape(ceilingShape, 0, 0);
    } else {
      shape(wallCeilingShape, 0, 0);
    }
  }
  
  /**
   * Affiche une représentation schématique du labyrinthe pour le débogage
   */
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
