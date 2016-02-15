/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/154517*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
ArrayList<Dot> dots;
ArrayList<Spider> spiders;
int step=10; 
//int num=1;
int num=10;

PGraphics spiderLayer, webLayer, realLayer, fixedLayer, coverAnimLayer;

//color col = color(66, 168, 237, 200);
color col = color(168, 168, 237, 200);

String[] lines;
int counter;

boolean draw2Phase = false;

ArrayList<PVector> path = new ArrayList<PVector>();

java.awt.Polygon pol = new java.awt.Polygon();

PImage objImage, obtImage1, fullImage;

//ArrayList<Animation> coverListsPool = new ArrayList<Animation>(); 


Path pathToHole, pathOutOfHole, pathFromHole;

Animation coverAnim;
AnimationPath tankAnimPath;




void setup() {
  size(1200, 800);
  
  lines = loadStrings("/Users/rwolfson/Documents/dev/spider/Path.txt");
  
  newPath();  
  
  
  objImage = loadImage("whitecover4.png");
  obtImage1 = loadImage("pillowcover1.png");
  fullImage = loadImage("whitecover0.png");
  spiders = new ArrayList<Spider>();
  
  coverAnimLayer = createGraphics(width, height);
  
  dots = new ArrayList<Dot>();
  for (int x=step/2; x<width; x+=step) {
    for (int y=step/2; y<height; y+= step) {
      dots.add(new Dot(x, y));
    }
  }
  for (int i=0; i<num; i++) {
    spiders.add(new Spider(random(100)));
  }
  
   spiderLayer = createGraphics(width-100, height-100);
   webLayer = createGraphics(width, height); 
   realLayer = createGraphics(width, height); 
   fixedLayer = createGraphics(width, height); 

  coverAnim = new Animation(fixedLayer,"cover",5,0,0);
  tankAnimPath = new AnimationPath(fixedLayer,pathToHole, "tank",4,755, 1160);

   

   buildPath(); 
}


//float[] prev = {0,0};

void buildPath(){

  for(int counter=0;counter<lines.length;counter++){
      float[] values = float(lines[counter].split("\t"));
      pol.addPoint((int)values[0],(int)values[1]);
      PVector p = new PVector(values[0],values[1]);
      path.add(p);
  }


}

int frameCountSlowFactor = 50;
int slowFrameCount = 0;



void draw() {
  
  if (moveTank){
    background(255);
    image(objImage,0,0,width,height);
  }
   
   realLayer.beginDraw();
   //realLayer.background(255,0);
   spiderLayer.beginDraw();
   spiderLayer.stroke(224, 122, 0);
   spiderLayer.background(255,0);
   webLayer.beginDraw();
   webLayer.stroke(204, 102, 0);
   webLayer.background(255,0);

    //background(255);
    for (Dot d : dots) {
      d.run();
    }
  
  
    if (moveTank){
        fixedLayer.beginDraw();
        fixedLayer.background(255,0);
        //fixedLayer.background(255);
        tankAnimPath.display(mouseX, mouseY);
        //tankAnimPath.display(0, 0);
        fixedLayer.endDraw();
        image(fixedLayer,0,0,width,height);        
    }
  
    if (fixPillow){
        spiderLayer.beginDraw();
        spiderLayer.stroke(224, 122, 0);
        spiderLayer.background(255,0);
        webLayer.beginDraw();
        webLayer.stroke(204, 102, 0);
        webLayer.background(255,0);
        spiderLayer.beginShape();
        spiderLayer.noFill();
        spiderLayer.strokeWeight(3);
        for (int i = 0; i < pol.npoints; i++) {
           spiderLayer.vertex(pol.xpoints[i], pol.ypoints[i]);
        }
        spiderLayer.endShape();
        
        for (Spider s : spiders) {
          s.run();
        }
        
        //realLayer.image(stripesImage,0,0);
        //realLayer.endDraw();
        spiderLayer.endDraw();
        webLayer.endDraw();
        image(webLayer,0,0);
        image(spiderLayer,0,0);
      
    } else if (paintCover){
        webLayer.beginDraw();
        webLayer.stroke(204, 102, 0);
        webLayer.background(255,0);
        spiderLayer.beginShape();
        spiderLayer.noFill();
        spiderLayer.strokeWeight(3);
        for (int i = 0; i < pol.npoints; i++) {
           spiderLayer.vertex(pol.xpoints[i], pol.ypoints[i]);
        }
        spiderLayer.endShape();
        
        for (Spider s : spiders) {
          s.run();
        }
        
        //realLayer.image(stripesImage,0,0);
        //realLayer.endDraw();
        spiderLayer.endDraw();
        webLayer.endDraw();
        image(webLayer,0,0);
        image(spiderLayer,0,0);
                
    }
    else if (showCover){
        fixedLayer.beginDraw();
        fixedLayer.background(255,0);
        if (!coverAnim.isStopOn()){
           coverAnim.displayFrame();
        } 
        fixedLayer.endDraw(); 
        image(fixedLayer,0,0,width,height);
    }else if (showFullCover){
       image(fullImage,0,0,width,height); 
    }
    
    
    textSize(32);
    fill(50);
    text("x,y="+mouseX+","+mouseY, 100,100);
    
  
  //if (frameCount%2==0 && frameCount<1200) saveFrame("image-####.gif");  
  
  if (frameCount % frameCountSlowFactor == 0){
      slowFrameCount = slowFrameCount + 1;
  }

}


void playCoverAppearance(){
    coverAnim.displayTarget(width,height);
    
}


//tab
boolean moveTank = true;

boolean fixPillow = false;
boolean fixCover = false;
boolean showCover = false;

boolean paintRing = false;
boolean paintCover = false;
int blendFrameCount = 1;
boolean showFullCover = false;


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      println("up pressed");
      fixPillow = true;
      moveTank = false;
    } else if (keyCode == DOWN) {
      println("down pressed");
      paintCover = true;
      //blendFrameCount = slowFrameCount;
      coverAnim.start();
    } else if (keyCode == RIGHT) {
      println("right pressed"); 
      //fixCover = true;
      fixPillow = false;
      paintCover = false;
      blendFrameCount = slowFrameCount;
      showCover = true;
    } else if (keyCode == LEFT) {
      println("left pressed"); 
      moveTank = false;
      paintCover = false;
      showCover = false;
      showFullCover = true;
    }
  }
}


void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  pathToHole = new Path();
  float offset = 10;
  pathToHole.addPoint(100, 230);  
  pathToHole.addPoint(110, 230);
  pathToHole.addPoint(120, 230);
  pathToHole.addPoint(130, 230);
  pathToHole.addPoint(140, 230);
  pathToHole.addPoint(150, 230);
  pathToHole.addPoint(160, 230);
  pathToHole.addPoint(170, 230);
  pathToHole.addPoint(180, 230);
  pathToHole.addPoint(190, 230);
  pathToHole.addPoint(200, 230);
  pathToHole.addPoint(210, 230);
  pathToHole.addPoint(220, 230);
  pathToHole.addPoint(230, 230);
  pathToHole.addPoint(240, 230);
  pathToHole.addPoint(250, 230);
  pathToHole.addPoint(260, 230);
  pathToHole.addPoint(270, 230);
  pathToHole.addPoint(280, 230);
  pathToHole.addPoint(290, 230);
  pathToHole.addPoint(300, 230);
  pathToHole.addPoint(310, 230);
  pathToHole.addPoint(320, 230);
  pathToHole.addPoint(330, 230);
  pathToHole.addPoint(340, 230);
  pathToHole.addPoint(350, 230);
  pathToHole.addPoint(360, 230);
  pathToHole.addPoint(370, 230);
  pathToHole.addPoint(380, 230);
  pathToHole.addPoint(390, 230);
  pathToHole.addPoint(400, 230);
  pathToHole.addPoint(410, 240);
  pathToHole.addPoint(420, 250);
}

//void newPath() {
//  // A path is a series of connected points
//  // A more sophisticated path might be a curve
//  pathToHole = new Path();
//  float offset = 10;
//  pathToHole.addPoint(755, 1160);  
//  pathToHole.addPoint(980, 1150);
//  pathToHole.addPoint(1059, 1115);
//  pathToHole.addPoint(1123, 1115);
//  pathToHole.addPoint(1207, 1083) ;
//  pathToHole.addPoint(1285, 1086);
//  pathToHole.addPoint(1362, 1038);  
//  pathToHole.addPoint(1414, 1083);
//  pathToHole.addPoint(1530, 1057);
//}


class Dot {

  float x, y, ox, oy;
  float r = 1.0;

  Dot(float _ox, float _oy) {
    ox = _ox;
    oy = _oy;
  }

  void run() {
    update();
    //display();
  }

  void update() {
    x = ox + random(-r, r);
    y = oy + random(-r, r);
  }

  void display() {
    spiderLayer.point(x, y);
  }
}

class Spider {

  float nx, ny, x, y,r;
  int edge = 100, dirx=1, diry=1, n=8;

  Spider(float _r) {
    //x = random(edge, width-edge);
    //y = random(edge, height-edge);
    x = random(400, 650);
    y = random(190, 360);
    r = _r;
  }

  void run() {
    update();
    connectedLines();
  }

  void update() {
    if (frameCount%100==0) r=random(1200);
    nx = map(noise(r+frameCount/10), 0, 1, -n, n)*dirx;
    ny = map(noise(r+frameCount/20), 0, 1, -n, n)*diry;
    x += nx;
    y += ny;
    if (x>650 || x<400) dirx *=-1;
    if (y>360 || y<190) diry *=-1;
  }

  void connectedLines() {
    for (Dot d : dots) {
      float distance = dist(x, y, d.x, d.y);
      if (distance>step*1.1 && distance<step*2 && pol.contains(d.x,d.y)) {
        if (paintCover){
           //webLayer.strokeWeight(2);
           webLayer.stroke(211, 201, 199);
        }
        webLayer.line(x, y, d.x, d.y);
        //line(x, y, d.x, d.y);
      }
      //if (distance>step*1.1 && distance<step*2) {
      // spiderLayer.line(x, y, d.x, d.y);
      // //line(x, y, d.x, d.y);
      //}
      //line(x, y, d.x, d.y);
    }
  }
}