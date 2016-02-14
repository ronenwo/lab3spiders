


PImage objImage;


int frameCountSlowFactor = 1;
int slowFrameCount = 0;

void setup(){
  size(1000,1000);
  objImage = loadImage("stripes1.jpeg");
  
  objImage.resize(width,height);
  
}

void draw(){
  
  int trans = 255 - slowFrameCount ;
 
  if (trans < 0){
     trans = 0; 
  }

  background(objImage);
  tint(255,255-frameCount);
  
    if (frameCount % frameCountSlowFactor == 0){
      slowFrameCount = slowFrameCount + 1;
      println("slowFrameCount = " + slowFrameCount);
  }
  
}