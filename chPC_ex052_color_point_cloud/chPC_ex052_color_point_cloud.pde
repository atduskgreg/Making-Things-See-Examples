import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;
float rotation = 0;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // access the color camera
  kinect.enableRGB();
  // tell OpenNI to line-up the color pixels
  // with the depth data
  kinect.alternativeViewPointDepthToImage();

}

void draw() {
  background(0);
  kinect.update();
  // load the color image from the Kinect
  PImage rgbImage = kinect.rgbImage();
  
  translate(width/2, height/2, -250);
  rotateX(radians(180));
  translate(0, 0, 1000);
  rotateY(radians(rotation));
  rotation++;

  PVector[] depthPoints = kinect.depthMapRealWorld();
  // don't skip any depth points
  for (int i = 0; i < depthPoints.length; i+=1) {
    PVector currentPoint = depthPoints[i];
    // set the stroke color based on the color pixel
    stroke(rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}
