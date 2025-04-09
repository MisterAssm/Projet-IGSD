class Sable{
  
  PShader shader;
  
   int tailleGrille ; // le nombre de points 
   float distance ; // la distance entre les points 
   float  amplitude; //  la taille de la hauteur de chaque point
   float facteurBruit ; //  la densité  des variations de la hauteur 
   
   Sable(int tailleGrille, float distance, float amplitude,float facteurBruit){
      this.tailleGrille=tailleGrille;
      this.distance=distance;
      this.amplitude=amplitude;
      this.facteurBruit=facteurBruit;
      
      shader = loadShader("assets/shaders/sable_frag.glsl");
      shader.set("lightDir", 0.5, 1.0, -0.8); 
   }
   
    void dessinerSable() {
      //appliquer le shader 
      shader(shader);
      background(190, 170, 255);
      noStroke();
      pushMatrix();
      
      // deplacer  le systeme de coords au milieu 
      translate(width / 2 - tailleGrille * distance / 2, height / 2 + 20, -200);
       
      for(int i=0;i<tailleGrille;i++) {
        beginShape(QUAD_STRIP);
        
        for (int j = 0; j <tailleGrille; j++) {
           // position d un point de la grille 
            float x1 = i*distance; 
            float y1 = j* distance;
            
              // la hauteur du point courant 
              float h1 = noise(i / facteurBruit, j / facteurBruit) * amplitude;
              //hauteur du point juste a droite 
              float h2 = noise((i + 1) / facteurBruit, j / facteurBruit) * amplitude;
             
             vertex(x1, h1, y1);
             vertex(x1 +distance, h2, y1);
          }
          
          endShape();
     }
     
     popMatrix(); 
     resetShader();
     
   }
   
  void dessinerDessert(float size, int resolution, float scale) {
     
      noStroke();
      textureMode(NORMAL);
      fill(255, 140, 0); // Couleur sable du désert
      
      for (int z = 0; z < resolution; z++) {
          beginShape(TRIANGLE_STRIP);
          for (int x = 0; x <= resolution; x++) {
              float xPos = map(x, 0, resolution, -size/2, size/2);
              float zPos = map(z, 0, resolution, -size/2, size/2);
              float zPos2 = map(z+1, 0, resolution, -size/2, size/2);
  
              // Utilisation des paramètres de la classe pour le bruit
              float h1 = noise(xPos*scale/facteurBruit, zPos*scale/facteurBruit) * amplitude;
              float h2 = noise(xPos*scale/facteurBruit, zPos2*scale/facteurBruit) * amplitude;
  
              // Mise à jour du shader
              float avgHeight = (h1 + h2) * 0.5;
              shader.set("height", avgHeight);
              
              vertex(xPos, h1, zPos);
              vertex(xPos, h2, zPos2);
          }
          endShape();
      }
     
  }   
 
}
 
 
 
