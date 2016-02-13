color col = color(66, 168, 237, 200);
float lineLength = width/5;
float angle = 45;
float angleSpeed = 7;

ArrayList<PVector> path = new ArrayList<PVector>();



void setup() {
  size(1200, 800);
  background(255);
  smooth();
  strokeWeight(0.3);
  stroke(col);
}

void draw() {
  PVector lastP = null;
  if (path.size() > 0){
    lastP = path.get(path.size()-1);
  }
  PVector p = new PVector(mouseX, mouseY);
  if (mouseX > 0 && mouseY > 0){
    path.add(p);
  }
  
  if (lastP != null && lastP.x > 0){ 
    line(lastP.x, lastP.y, mouseX, mouseY);
  }
  translate(mouseX, mouseY);
  //rotate(radians(angle));
  
  //lineLength = random(width/4, height/2);

  //angle += angleSpeed-10;
}

void keyPressed()
{
  PVector p1 = path.get(0);
  path.add(p1);
  
  String[] lines = new String[path.size()];
  int c = 0;
  for (PVector p : path)
  {
    lines[c++] = p.x + "\t" + p.y;
  }
  saveStrings("/Users/rwolfson/Documents/dev/spider/Path.txt", lines); // Change path there
  exit();
}