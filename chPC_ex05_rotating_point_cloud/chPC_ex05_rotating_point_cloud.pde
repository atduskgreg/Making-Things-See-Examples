import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

// variable to hold our current rotation
// represented in degrees
float rotation = 0;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw() {
  background(0);
  kinect.update();

  // prepare to draw centered in x-y
  // pull it 1000 pixels closer on z
  translate(width/2, height/2, -1000);
  // flip the point cloud vertically:
  rotateX(radians(180));

  // move the center of rotation
  // to inside the point cloud
  translate(0, 0, 1000);

  // rotate about the y-axis
  // and bump the rotation
  rotateY(radians(rotation));
  rotation++;

  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  // notice: "i+=10"
  // only draw every 10th point to make things faster
  for (int i = 0; i < depthPoints.length; i+=10) {
    PVector currentPoint = depthPoints[i];
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}

