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
      
      shader = loadShader("sable_frag.glsl");
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
     
     for(int i=0;i<tailleGrille;i++)
     {
         beginShape(QUAD_STRIP);
        for (int j = 0; j <tailleGrille; j++) 
          {
            // position d un point de la grille 
            float x1 = i*distance; 
            float y1 = j* distance;
            
              // la hauteur du point courant 
              float h1 = noise(i / facteurBruit, j / facteurBruit) * amplitude;
              //hauteur du point juste a droite 
              float h2 = noise((i + 1) / facteurBruit, j / facteurBruit) * amplitude;
            
            
             // ajouter une deuxieme couche  de buit 
             // h1 += noise(i / (facteurBruit * 0.5), j / (facteurBruit* 0.5)) * 10;
             // h2 += noise((i + 1) / (facteurBruit * 0.5), j / (facteurBruit * 0.5)) * 10;
               float avgHeight = (h1 + h2) * 0.5;
               shader.set("height", avgHeight);
             
             
             vertex(x1, h1, y1);
             vertex(x1 +distance, h2, y1);
          }
          endShape();
         
     }
     popMatrix(); 
     
     // desactiver le shader
     resetShader();
     
   }
  
}
