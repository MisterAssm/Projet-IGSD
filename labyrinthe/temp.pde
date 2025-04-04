/*void temp() {
  translate(BOX_SIZE, BOX_SIZE);
  
  for (int j=0; j<LAB_SIZE; j++) {
    for (int i=0; i<LAB_SIZE; i++) {
      
      pushMatrix();
      translate(j * BOX_SIZE, i * BOX_SIZE);
      beginShape(QUADS);
      
      if (labyrinthe[i][j] == '#') {
         fill(255, 255, 255);
        
         // bas (cote cube haut)
         if (i != 0 && labyrinthe[i - 1][j] == ' ') {
           if (sides[i][j][3] == 1) {
             fill(0, 255, 0);
           }
           
           vertex(0, 0, 0); // bas gauche
           vertex(0, 0, BOX_SIZE); // haut gauche
           vertex(BOX_SIZE, 0, BOX_SIZE); // haut droite
           vertex(BOX_SIZE, 0, 0); // bas droite
           
           fill(255, 255, 255);
         }
         
         // droite (cote cube gauche)
         if (j != 0 && labyrinthe[i][j - 1] == ' ') {
           if (sides[i][j][1] == 1) {
             fill(255, 0, 255);
           }
           
           vertex(0, 0, 0); // bas gauche
           vertex(0, 0, BOX_SIZE); // haut gauche
           vertex(0, BOX_SIZE, BOX_SIZE); 
           vertex(0, BOX_SIZE, 0);
           
           fill(255, 255, 255);
         }
         
         // gauche (cote cube droit)
         if (j != LAB_SIZE - 1 && labyrinthe[i][j + 1] == ' ') {
           if (sides[i][j][2] == 1) {
             fill(255, 255, 0);
           }
           
           vertex(BOX_SIZE, 0, 0); // bas droite
           vertex(BOX_SIZE, 0, BOX_SIZE); // haut droite
           vertex(BOX_SIZE, BOX_SIZE, BOX_SIZE);
           vertex(BOX_SIZE, BOX_SIZE, 0);
       
           if (!camoufle[i][j]) {
             fill(128, 0, 0);
                       
            // Face avant
            vertex(0, 0, BOX_SIZE); // haut gauche
            vertex(BOX_SIZE, 0, BOX_SIZE); // haut droite
            vertex(BOX_SIZE, BOX_SIZE, BOX_SIZE); // bas droite
            vertex(0, BOX_SIZE, BOX_SIZE); // bas gauche
          
            // Face arrière
            vertex(0, 0, 0); // bas gauche
            vertex(BOX_SIZE, 0, 0); // bas droite
            vertex(BOX_SIZE, BOX_SIZE, 0); // haut droite
            vertex(0, BOX_SIZE, 0); // haut gauche
          
            // Face gauche
            vertex(0, 0, 0); // bas gauche
            vertex(0, 0, BOX_SIZE); // haut gauche
            vertex(0, BOX_SIZE, BOX_SIZE); // haut droite
            vertex(0, BOX_SIZE, 0); // bas droite
          
            // Face inférieure
            vertex(0, 0, 0); // bas gauche
            vertex(BOX_SIZE, 0, 0); // bas droite
            vertex(BOX_SIZE, 0, BOX_SIZE); // haut droite
            vertex(0, 0, BOX_SIZE); // haut gauche
          
            // Face supérieure
            vertex(0, BOX_SIZE, 0); // bas gauche
            vertex(BOX_SIZE, BOX_SIZE, 0); // bas droite
            vertex(BOX_SIZE, BOX_SIZE, BOX_SIZE); // haut droite
            vertex(0, BOX_SIZE, BOX_SIZE); // haut gauche
           }
           
           fill(255, 255, 255);
         }
           
         // haut (cote cube bas)
         if (i != LAB_SIZE - 1 && labyrinthe[i + 1][j] == ' ') {
           if (sides[i][j][0] == 1) {
             fill(0, 0, 255);
           }
           
           vertex(0, BOX_SIZE, 0); // bas gauche arrière
           vertex(0, BOX_SIZE, BOX_SIZE); // haut gauche arrière
           vertex(BOX_SIZE, BOX_SIZE, BOX_SIZE); // haut droite arrière
           vertex(BOX_SIZE, BOX_SIZE, 0); // bas droite arrière
           
           fill(255, 255, 255);
         }
      } else {
        fill(58, 58, 58);
        
        vertex(0, 0, 0);
        vertex(BOX_SIZE, 0, 0);
        vertex(BOX_SIZE, BOX_SIZE, 0);
        vertex(0, BOX_SIZE, 0);
      }
      
      endShape();
      popMatrix();
    }
  }
}*/
