import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup()
{
  // double the width to display two images side by side
  size(640*2, 480);
  kinect = new SimpleOpenNI(this);

  kinect.enableDepth();  
  kinect.enableRGB();
}

void draw()
{
  kinect.update();

  PImage depthImage = kinect.depthImage();
  PImage rgbImage = kinect.rgbImage();
 
  image(depthImage, 0, 0);
  image(rgbImage, 640, 0);
}

