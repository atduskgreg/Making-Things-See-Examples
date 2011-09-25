import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;

void setup() {
  size(640, 480, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // turn on access to the scene
  kinect.enableScene();
}

void draw() {
  background(0);
  kinect.update();
  // draw the scene image
  image(kinect.sceneImage(), 0, 0);
}
