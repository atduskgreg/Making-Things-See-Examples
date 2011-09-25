import processing.opengl.*;
import unlekker.util.*;
import unlekker.modelbuilder.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

boolean scanning = false;

int maxZ = 2000;
int spacing = 3;

UGeometry model;
UVertexList vertexList;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();

  model = new UGeometry();
  vertexList = new UVertexList();
}

void draw() {
  background(0);

  kinect.update();

  translate(width/2, height/2, -1000);
  rotateX(radians(180));

  PVector[] depthPoints = kinect.depthMapRealWorld();

  if (scanning) {
    model.beginShape(TRIANGLES);
    fill(255);
    text("PERFORMING SCAN...", 5, 10);
  }

  for (int y = 0; y < 480 -spacing; y+=spacing) {
    for (int x = 0; x < 640 -spacing; x+= spacing) { 
      int i = y * 640 + x;           

      int nw = i;
      int ne = nw + spacing;
      int sw = i + 640 * spacing;
      int se = sw + spacing;

      if (scanning) {
        model.addFace(new UVec3(depthPoints[nw].x, depthPoints[nw].y, depthPoints[nw].z), 
        new UVec3(depthPoints[ne].x, depthPoints[ne].y, depthPoints[ne].z), 
        new UVec3(depthPoints[sw].x, depthPoints[sw].y, depthPoints[sw].z));

        model.addFace(new UVec3(depthPoints[ne].x, depthPoints[ne].y, depthPoints[ne].z), 
        new UVec3(depthPoints[se].x, depthPoints[se].y, depthPoints[se].z), 
        new UVec3(depthPoints[sw].x, depthPoints[sw].y, depthPoints[sw].z));
        
        

      } 
      else {
        stroke(255);
        PVector currentPoint = depthPoints[i];
        point(currentPoint.x, currentPoint.y, currentPoint.z);
      }
    }

    if (scanning) {
      model.endShape();
      model.writeSTL(this, "scan_"+random(1000)+".stl");
      scanning = false;
    }
  }


  void keyPressed() {
    if (key == ' ') {
      scanning = true;
    }
  }

