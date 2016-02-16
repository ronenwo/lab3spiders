


class AnimationPath {
  PImage[] images;
  int imageCount;
  int frame;
  float xpos, ypos;
  PGraphics layer; 
  Path path;
  
  
  AnimationPath(PGraphics layer,Path path, String imagePrefix, int count, float xpos, float ypos) {
    this.layer = layer;  
    this.xpos = xpos;
    this.ypos = ypos;
    this.path = path;
    
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + (i + 1) + ".png";
      images[i] = loadImage(filename);
      images[i].resize(0,70);
      println("image loaded="+filename);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    PVector point = path.nextToEnd();
    if (path.isEnd()){
       layer.image(images[0], point.x, point.y);
    }
    else{
      layer.image(images[frame], point.x, point.y);
    }
  }
  
  
  boolean isPathEnd(){
     return path.isEnd(); 
  }
  
  
  
  int getWidth() {
    return images[0].width;
  }
}