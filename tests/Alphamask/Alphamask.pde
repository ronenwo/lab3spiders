/**
 * Alpha Mask. 
 * 
 * Loads a "mask" for an image to specify the transparency 
 * in different parts of the image. The two images are blended
 * together using the mask() method of PImage. 
 */

PImage img;
PImage imgMask;

void setup() {
  size(640, 360);
  img = loadImage("moonwalk.jpg");
  imgMask = loadImage("pillowcover1.png");
  imgMask.resize(width,height);
  img.mask(imgMask);
  imageMode(CENTER);
}

void draw() {
  background(0, 102, 153);
  image(img, width/2, height/2);
  image(img, mouseX, mouseY);
}