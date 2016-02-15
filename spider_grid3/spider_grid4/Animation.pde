



class Animation {
  
  boolean reverse = false;
  boolean oneShot = true; 
  PGraphics layer;
  PImage[] images;
  int imageCount;
  int frame;
  int tick;
  float targetX, targetY;
  
  int startFrame = 0;
  
  Animation(PGraphics layer, String imagePrefix, int count, float tx, float ty) {
    this.layer = layer;
    imageCount = count;
    images = new PImage[imageCount];
    targetX = tx; targetY = ty;

      
      for (int i = 1; i <= imageCount; i++) {
        // Use nf() to number format 'i' into four digits
        String filename = imagePrefix + i + ".png";
        if (reverse){
            images[imageCount-i] = loadImage(filename);
        }
        else{
          images[i-1 ] = loadImage(filename);
  //      images[i-1].resize(200,200);
        }
        println("image loaded="+filename);
      }
    
  }
  
  
  
  void update(float tx, float ty){
    targetX = tx; 
    targetY = ty;
  }

  boolean isStopOn(){
     return stopOn; 
  }

  int getFrameCount(){
//      int frameRatio = Math.round(frameCount / imageCount);
      int count = frameCount % Math.round(frameRate);
      count = Math.round(count / imageCount) + 1;
      count = count % imageCount;
      return count;
  }

  boolean stopOn = false;

   int getSlowFrameCount(){
//      int frameRatio = Math.round(frameCount / imageCount);
      int count = slowFrameCount - startFrame +1 % imageCount ;
      println("count = " + count);
      if (count == imageCount || count == 0 || stopOn ){
         count = imageCount - 1;
         stopOn = true;
      }

      return count;
  }



  float getX(){
     return targetX;  
  }
  
  float getY(){
     return targetY;  
  }

  void display(float xpos, float ypos, int w, int h) {
    frame = getFrameCount() ;
//    println("image frame="+frame);
//    images[frame].resize(getWidth()+5,0);
    layer.image(images[frame], xpos, ypos, w, h);
  }

  void start(){
    startFrame = slowFrameCount;
    stopOn = false;
  }
  
  void displayFrame() {
    if (stopOn){
       return; 
    }
    frame = getSlowFrameCount() ;
//    println("image frame="+frame);
//    images[frame].resize(getWidth()+5,0);
    if (frame >= imageCount){
      layer.image(images[imageCount-1], 0, 0, width, height);
    }
    else{
      layer.image(images[frame], 0, 0, width, height);
    }
  }


  void displayTarget(int w, int h) {
//    frame = getFrameCount() ;
//    println("image frame="+frame);
//    images[frame].resize(getWidth()+5,0);
    layer.image(images[imageCount-1], targetX, targetY, w, h);
  }

  
  int getWidth() {
    return images[0].width;
  }
}