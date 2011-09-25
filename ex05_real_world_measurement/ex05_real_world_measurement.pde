import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);

  kinect.enableDepth();  
}

void draw()
{
  kinect.update();

  PImage depthImage = kinect.depthImage();
 
  image(depthImage, 0, 0);
}

void mousePressed(){
  int[] depthValues = kinect.depthMap();
  int clickPosition = mouseX + (mouseY * 640);
  
  int millimeters = depthValues[clickPosition];
  float inches = millimeters / 25.4;
  
  println("mm: " + millimeters + " in: " + inches);
}
