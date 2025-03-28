class GenerateurLabyrinthe {
  void genererLabyrinthe(char[][] labyrinthe, char[][][] cotes) {
    int taille = labyrinthe.length;
    int aCreuser = 0;

    for (int j = 0; j < taille; j++) {
      for (int i = 0; i < taille; i++) {
        cotes[j][i][0] = 0;
        cotes[j][i][1] = 0;
        cotes[j][i][2] = 0;
        cotes[j][i][3] = 0;

        if (j % 2 == 1 && i % 2 == 1) {
          labyrinthe[j][i] = '.';
          aCreuser++;
        } else {
          labyrinthe[j][i] = '#';
        }
      }
    }

    int posX = 1;
    int posY = 1;
    while (aCreuser > 0) {
      int ancienX = posX;
      int ancienY = posY;
      int alea = floor(random(4));

      if      (alea == 0 && posX > 1)           posX -= 2;
      else if (alea == 1 && posY > 1)           posY -= 2;
      else if (alea == 2 && posX < taille - 2)  posX += 2;
      else if (alea == 3 && posY < taille - 2)  posY += 2;

      if (labyrinthe[posY][posX] == '.') {
        aCreuser--;
        labyrinthe[posY][posX] = ' ';
        labyrinthe[(posY + ancienY) / 2][(posX + ancienX) / 2] = ' ';
      }
    }

    labyrinthe[0][1] = ' ';
    labyrinthe[taille - 2][taille - 1] = ' ';

    for (int j = 1; j < taille - 1; j++) {
      for (int i = 1; i < taille - 1; i++) {
        if (labyrinthe[j][i] == ' ') {
          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]==' ' &&
              labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
            cotes[j-1][i][0] = 1;

          if (labyrinthe[j-1][i]==' ' && labyrinthe[j+1][i]=='#' &&
              labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
            cotes[j+1][i][3] = 1;

          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
              labyrinthe[j][i-1]==' ' && labyrinthe[j][i+1]=='#')
            cotes[j][i+1][1] = 1;

          if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
              labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]==' ')
            cotes[j][i-1][2] = 1;
        }
      }
    }
  }
}
