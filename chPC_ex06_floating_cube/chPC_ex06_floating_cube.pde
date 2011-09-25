import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

float rotation = 0;

// set the box size
int boxSize = 150;
// a vector holding the center of the box
PVector boxCenter = new PVector(0, 0, 600);

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw() {
  background(0);
  kinect.update();

  translate(width/2, height/2, -1000);
  rotateX(radians(180));

  translate(0, 0, 1000);
  
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  
  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  for (int i = 0; i < depthPoints.length; i+=10) {
    PVector currentPoint = depthPoints[i];

    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  
  // move to the box center
  translate(boxCenter.x, boxCenter.y, boxCenter.z);
  // set line color to red
  stroke(255, 0, 0);
  // leave the box unfilled so we can see through it
  noFill();
  // draw the box
  box(boxSize);
}

