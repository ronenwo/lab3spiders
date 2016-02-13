/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/154517*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
ArrayList<Dot> dots;
ArrayList<Spider> spiders;
int step=30; 
//int num=1;
int num=10;

PGraphics spiderLayer, webLayer;

color col = color(66, 168, 237, 200);

String[] lines;
int counter;

boolean draw2Phase = false;

ArrayList<PVector> path = new ArrayList<PVector>();

java.awt.Polygon pol = new java.awt.Polygon();


void setup() {
  size(1200, 800);
  
  lines = loadStrings("/Users/rwolfson/Documents/dev/spider/Path.txt");
  
  spiders = new ArrayList<Spider>();
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

void draw() {
  
  //background(255);
   spiderLayer.beginDraw();
  spiderLayer.background(255,0);
   webLayer.beginDraw();
   webLayer.background(255,0);

  //background(255);
  for (Dot d : dots) {
    d.run();
  }
  
  spiderLayer.beginShape();
  spiderLayer.noFill();
  for (int i = 0; i < pol.npoints; i++) {
   spiderLayer.vertex(pol.xpoints[i], pol.ypoints[i]);
  }
  spiderLayer.endShape();
  
  for (Spider s : spiders) {
    s.run();
  }
  
  spiderLayer.endDraw();
  webLayer.endDraw();
  
  image(webLayer,0,0);
  image(spiderLayer,0,0);
  
  //if (frameCount%2==0 && frameCount<1200) saveFrame("image-####.gif");  
}

class Dot {

  float x, y, ox, oy;
  float r = 1.0;

  Dot(float _ox, float _oy) {
    ox = _ox;
    oy = _oy;
  }

  void run() {
    update();
    display();
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
    x = random(edge, width-edge);
    y = random(edge, height-edge);
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
    if (x>width || x<0) dirx *=-1;
    if (y>height || y<0) diry *=-1;
  }

  void connectedLines() {
    for (Dot d : dots) {
      float distance = dist(x, y, d.x, d.y);
      if (distance>step*1.1 && distance<step*2 && pol.contains(d.x,d.y)) {
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