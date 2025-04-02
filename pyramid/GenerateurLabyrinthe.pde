class GenerateurLabyrinthe {
  void genererLabyrinthe(char[][] labyrinthe, char[][][] cotes) {
    int taille = labyrinthe.length;
    int aCreuser = 0;
    
    initialiserLabyrinthe(labyrinthe, cotes, taille);
    aCreuser = compterZonesACreuser(labyrinthe, taille);
    creuserLabyrinthe(labyrinthe, taille, aCreuser);
    definirEntreesSorties(labyrinthe, taille);
    definirCotes(labyrinthe, cotes, taille);
  }
  
  void initialiserLabyrinthe(char[][] labyrinthe, char[][][] cotes, int taille) {
    for (int j = 0; j < taille; j++) {
      for (int i = 0; i < taille; i++) {
        for (int k = 0; k < 4; k++) {
          cotes[j][i][k] = 0;
        }
        labyrinthe[j][i] = (j % 2 == 1 && i % 2 == 1) ? '.' : '#';
      }
    }
  }
  
  int compterZonesACreuser(char[][] labyrinthe, int taille) {
    int count = 0;
    for (int j = 1; j < taille; j += 2) {
      for (int i = 1; i < taille; i += 2) {
        if (labyrinthe[j][i] == '.') {
          count++;
        }
      }
    }
    return count;
  }
  
  void creuserLabyrinthe(char[][] labyrinthe, int taille, int aCreuser) {
    int posX = 1, posY = 1;
    while (aCreuser > 0) {
      int ancienX = posX, ancienY = posY;
      int alea = floor(random(4));
      
      switch (alea) {
        case 0: if (posX > 1) posX -= 2; break;
        case 1: if (posY > 1) posY -= 2; break;
        case 2: if (posX < taille - 2) posX += 2; break;
        case 3: if (posY < taille - 2) posY += 2; break;
      }
      
      if (labyrinthe[posY][posX] == '.') {
        aCreuser--;
        labyrinthe[posY][posX] = ' ';
        labyrinthe[(posY + ancienY) / 2][(posX + ancienX) / 2] = ' ';
      }
    }
  }
  
  void definirEntreesSorties(char[][] labyrinthe, int taille) {
    labyrinthe[0][1] = ' ';
    labyrinthe[taille - 2][taille - 1] = ' ';
  }
  
  void definirCotes(char[][] labyrinthe, char[][][] cotes, int taille) {
    for (int j = 1; j < taille - 1; j++) {
      for (int i = 1; i < taille - 1; i++) {
        if (labyrinthe[j][i] == ' ') {
          boolean hautMur = labyrinthe[j-1][i] == '#';
          boolean basMur = labyrinthe[j+1][i] == '#';
          boolean gaucheMur = labyrinthe[j][i-1] == '#';
          boolean droiteMur = labyrinthe[j][i+1] == '#';
      
          if (hautMur && !basMur && gaucheMur && droiteMur) 
              cotes[j-1][i][0] = 1; // Mur en haut
      
          if (!hautMur && basMur && gaucheMur && droiteMur) 
              cotes[j+1][i][3] = 1; // Mur en bas
      
          if (hautMur && basMur && !gaucheMur && droiteMur) 
              cotes[j][i+1][1] = 1; // Mur à droite
      
          if (hautMur && basMur && gaucheMur && !droiteMur) 
              cotes[j][i-1][2] = 1; // Mur à gauche
          }
      }
    }
  }
}
