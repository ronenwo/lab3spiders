/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/109715*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
// Copyright Olivier Baudu 2013 for the Labomedia
// Published under the terms of the GPL v3.0 license
// http://labomedia.org

PGraphics spiderLayer, webLayer;

Patte[] pattes;

PVector positionCorps, positionCorpsPers;
int taillePatte, nbPatte;

float x,y,z;

void setup() {

  
  
  ///////// 
  taillePatte = 100;
  nbPatte = 20;
  /////////

  //size(1000, 1000, P3D);
  size(1000, 1000);

  x = width/2;
  y = height/2;
  z = 50;

  //spiderLayer = createGraphics(width, height,P3D);
  //webLayer = createGraphics(width, height,P3D); 
  spiderLayer = createGraphics(width, height);
  webLayer = createGraphics(width, height); 
  
  smooth();
  noCursor();
  
 

  pattes = new Patte[nbPatte];

  for (int i=0; i<pattes.length; i++) {
    pattes[i] = new Patte(taillePatte);
  }
}

void draw() {

  //translate(x,y,z);
  
  spiderLayer.beginDraw();
  spiderLayer.background(255,0);
  
  positionCorps = new PVector(mouseX, mouseY);
  positionCorpsPers = new PVector(mouseX, mouseY+taillePatte/4);

  for (int i=0; i<pattes.length; i++) {

    if (pattes[i].positionPied.dist(positionCorps) > taillePatte) {
      pattes[i].initDeplacement();
    }

    pattes[i].dessine(positionCorps);
    if (i>0){
      webLayer.beginDraw();
      //webLayer.translate(x,y,z);
      webLayer.line(pattes[i].positionPied.x,pattes[i].positionPied.y, pattes[i-1].positionPied.x,pattes[i-1].positionPied.y);
      webLayer.endDraw();
    }
  }

  
  spiderLayer.ellipse(positionCorps.x, positionCorps.y, 10, 5);
  spiderLayer.endDraw();
  
  image(spiderLayer,0,0);
  image(webLayer,0,0);
    //image(spiderLayer,width,height);

}

class Patte {

  PVector posCorps, positionPied, detinationPied;
  PVector vitesse, trajet;
  ;
  boolean action;
  int tangente, valBruit;


  Patte(int sizePatte) {

    action = false;
    valBruit = sizePatte*3/2;
    tangente = sizePatte/2;

    // Définie une position près du corps mais pas trop...
    positionPied = new PVector(0, 0);
  }

  void dessine (PVector corps) {

    posCorps = corps;

    // Dessine la pattes
    spiderLayer.noFill();
    spiderLayer.bezier(posCorps.x, posCorps.y, posCorps.x, posCorps.y, 
    positionPied.x, positionPied.y-tangente, positionPied.x, positionPied.y);

    // Dessine les pieds
    spiderLayer.fill(0);
    spiderLayer.ellipse(positionPied.x, positionPied.y, 3, 3);

    if (action) {
      changePlace();
    }
  }

  void initDeplacement() {
    action = true;

    // Définie une nouvelle position pour le pied
    detinationPied = new PVector(mouseX+bruit(valBruit), mouseY+bruit(valBruit)+tangente);

    // Détermine le vecteur qui part de la position actuelle 
    // et arriver à la nouvelle position
    trajet = PVector.sub(detinationPied, positionPied);

    // Détermine la vitesse comme fraction du trajet
    vitesse = PVector.div(trajet, 10);
  }

  void changePlace() {
    
//    checkEdges();

    // Si la distance à parcourir n'est pas nulle...
    if (positionPied.dist(detinationPied) > 0.1) {
      // ... le pied se déplace
      positionPied.add(vitesse);
    }
    else {
      // ... sinon la fonction n'est plus appelée
      action = false;
    }
  }

  int bruit(int val) {
    return(int(random(val)-val/2));
  }
   
}