

class Pyramide {
  ArrayList<DonneesEtage> etages;
  float tailleCellule;
  float hauteurNiveau;
  PShape groupeMurs;
  PImage texturePierre;
  
  Pyramide(int tailleBase, int nbEtages, float tailleCellule, float hauteurNiveau, PImage texturePierre) {
    this.tailleCellule = tailleCellule;
    this.hauteurNiveau = hauteurNiveau;
    this.texturePierre = texturePierre;
    this.etages = new ArrayList<DonneesEtage>();
    this.groupeMurs = createShape(GROUP);
    
    for (int i = 0; i < nbEtages; i++) {
      int taille = tailleBase - 2 * i;
      if (taille <= 0) break;

      DonneesEtage etage = new DonneesEtage();
      etage.larg = taille;
      etage.haut = taille;
      etage.laby = new int[taille][taille];

      char[][] labyrinthe = new char[taille][taille];
      char[][][] cotes = new char[taille][taille][4];
      GenerateurLabyrinthe generateur = new GenerateurLabyrinthe();
      generateur.genererLabyrinthe(labyrinthe, cotes);

      for (int y = 0; y < taille; y++) {
        for (int x = 0; x < taille; x++) {
          etage.laby[y][x] = (labyrinthe[y][x] == '#' ? 1 : 0);
        }
      }

      etage.decalX = -taille * tailleCellule / 2;
      etage.decalY = -taille * tailleCellule / 2;
      etage.decalZ = i * hauteurNiveau;

      etages.add(etage);
    }
    
    creerCoquePyramide();
  }
  
  void creerCoquePyramide() {
    textureMode(NORMAL);
    textureWrap(REPEAT);
    
    for (int i = 0; i < etages.size() - 1; i++) {
      DonneesEtage base = etages.get(i);
      DonneesEtage sommet = etages.get(i+1);

      float bx0 = base.decalX;
      float bx1 = base.decalX + base.larg * tailleCellule;
      float by0 = base.decalY;
      float by1 = base.decalY + base.haut * tailleCellule;
      float bz = base.decalZ;

      float tx0 = sommet.decalX;
      float tx1 = sommet.decalX + sommet.larg * tailleCellule;
      float ty0 = sommet.decalY;
      float ty1 = sommet.decalY + sommet.haut * tailleCellule;
      float tz = sommet.decalZ;
      
      PShape mur = createShape();
      mur.beginShape(QUADS);
      mur.texture(texturePierre);
      mur.noStroke();
      mur.vertex(bx0, by0, bz, 0, 0);
      mur.vertex(bx1, by0, bz, 1, 0);
      mur.vertex(tx1, ty0, tz, 1, 1);
      mur.vertex(tx0, ty0, tz, 0, 1);
      
      mur.vertex(bx1, by1, bz, 0, 0);
      mur.vertex(bx0, by1, bz, 1, 0);
      mur.vertex(tx0, ty1, tz, 1, 1);
      mur.vertex(tx1, ty1, tz, 0, 1);
     
      mur.vertex(bx0, by1, bz, 0, 0);
      mur.vertex(bx0, by0, bz, 1, 0);
      mur.vertex(tx0, ty0, tz, 1, 1);
      mur.vertex(tx0, ty1, tz, 0, 1);
      
      mur.vertex(bx1, by0, bz, 0, 0);
      mur.vertex(bx1, by1, bz, 1, 0);
      mur.vertex(tx1, ty1, tz, 1, 1);
      mur.vertex(tx1, ty0, tz, 0, 1);
      mur.endShape();
      groupeMurs.addChild(mur);
    }
  }
  
  void dessiner() {
    dessinerEtages();
    dessinerSommetPyramide(180);
  }
  
  void dessinerEtages() {
    for (int i = 0; i < etages.size(); i++) {
      dessinerSolEtage(etages.get(i));
    }
    shape(groupeMurs);
  }
  
  void dessinerSolEtage(DonneesEtage etage) {
    textureMode(NORMAL);
    textureWrap(REPEAT);

    for (int i = 0; i < etage.haut; i++) {
      for (int j = 0; j < etage.larg; j++) {
        if (etage.laby[i][j] == 1) continue;

        float x = etage.decalX + j * tailleCellule;
        float y = etage.decalY + i * tailleCellule;
        float z = etage.decalZ;

        noStroke();
        beginShape(QUADS);
        texture(texturePierre);
        vertex(x, y, z, 0, 0);
        vertex(x + tailleCellule, y, z, 1, 0);
        vertex(x + tailleCellule, y + tailleCellule, z, 1, 1);
        vertex(x, y + tailleCellule, z, 0, 1);
        endShape();
      }
    }
  }
  
  void dessinerSommetPyramide(float hauteur) {
    textureMode(NORMAL);
    textureWrap(REPEAT);

    DonneesEtage dernierEtage = etages.get(etages.size() - 1);
    float tailleBase = dernierEtage.larg;
    float demiBase = tailleBase * tailleCellule / 2;
    float zSommet = dernierEtage.decalZ + hauteur;

    float centreX = 0;
    float centreY = 0;

    float baseX0 = -demiBase;
    float baseX1 = demiBase;
    float baseY0 = -demiBase;
    float baseY1 = demiBase;

    beginShape(TRIANGLES);
    texture(texturePierre);

    // Face avant
    vertex(baseX0, baseY0, dernierEtage.decalZ, 0, 1);
    vertex(baseX1, baseY0, dernierEtage.decalZ, 1, 1);
    vertex(centreX, centreY, zSommet, 0.5, 0);

    // Face droite
    vertex(baseX1, baseY0, dernierEtage.decalZ, 0, 1);
    vertex(baseX1, baseY1, dernierEtage.decalZ, 1, 1);
    vertex(centreX, centreY, zSommet, 0.5, 0);

    // Face arrière
    vertex(baseX1, baseY1, dernierEtage.decalZ, 0, 1);
    vertex(baseX0, baseY1, dernierEtage.decalZ, 1, 1);
    vertex(centreX, centreY, zSommet, 0.5, 0);

    // Face gauche
    vertex(baseX0, baseY1, dernierEtage.decalZ, 0, 1);
    vertex(baseX0, baseY0, dernierEtage.decalZ, 1, 1);
    vertex(centreX, centreY, zSommet, 0.5, 0);

    endShape();
  }
}
