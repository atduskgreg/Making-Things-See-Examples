import processing.opengl.*;
import SimpleOpenNI.*;
import saito.objloader.*;
import peasy.*;

PeasyCam cam;
SimpleOpenNI kinect;
OBJModel model;
Hotpoint hotpoint1;
Hotpoint hotpoint2;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();

  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  model.translateToCenter();
  noStroke();

  cam = new PeasyCam(this, 0, 0, 0, 1000);

  hotpoint1 = new Hotpoint(200, 200, 800, 150);
  hotpoint2 = new Hotpoint(-200, 200, 800, 150);
}

void draw() {
  background(0);
  kinect.update();

  rotateX(radians(180));

  lights();
  noStroke();

  pushMatrix();
    rotateX(radians(-90));
    rotateZ(radians(180));
    model.draw();
  popMatrix();
 

  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();

  for (int i = 0; i < depthPoints.length; i+=10) {
    PVector currentPoint = depthPoints[i];
    point(currentPoint.x, currentPoint.y, currentPoint.z);

    hotpoint1.check(currentPoint);
    hotpoint2.check(currentPoint);
  }

  hotpoint1.draw();
  hotpoint2.draw();
  
  if (hotpoint1.isHit()) {
    cam.lookAt(hotpoint1.center.x, hotpoint1.center.y * -1, hotpoint1.center.z * -1, 500, 500);
  }
  
  if (hotpoint2.isHit()) {
    cam.lookAt(hotpoint2.center.x, hotpoint2.center.y * -1, hotpoint2.center.z * -1, 500, 500);
  }  

  hotpoint1.clear();
  hotpoint2.clear();
}

