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

  if (scanning) {
    model.beginShape(TRIANGLES);
  }

  PVector[] depthPoints = kinect.depthMapRealWorld();

  // cleanup pass
  for (int y = 0; y < 480; y+=spacing) {
    for (int x = 0; x < 640; x+= spacing) { 
      int i = y * 640 + x;
      PVector p = depthPoints[i];
      // if the point is on the edge or if it has no depth
      if (p.z < 10 || p.z > maxZ || y == 0 || y == 480 - spacing || x == 0 || x == 640 - spacing) {
        // replace it with a point at the depth of the backplane (i.e. maxZ)
        PVector realWorld = new PVector();
        PVector projective = new PVector(x, y, maxZ);
        // to get the point in the right place, we need to translate
        // from x/y to realworld coordinates to match our other points:
        kinect.convertProjectiveToRealWorld(projective, realWorld);

        depthPoints[i] = realWorld;
      }
    }
  }

  for (int y = 0; y < 480 - spacing; y+=spacing) {
    for (int x = 0; x < 640 -spacing; x+= spacing) { 
      int i = y * 640 + x;           

      if (scanning) {
        int nw = i;
        int ne = nw + spacing;
        int sw = i + 640 * spacing;
        int se = sw + spacing;

        if (!allZero(depthPoints[nw]) && !allZero(depthPoints[ne]) && !allZero(depthPoints[sw]) && !allZero(depthPoints[se])) {

          model.addFace(new UVec3(depthPoints[nw].x, depthPoints[nw].y, depthPoints[nw].z), 
          new UVec3(depthPoints[ne].x, depthPoints[ne].y, depthPoints[ne].z), 
          new UVec3(depthPoints[sw].x, depthPoints[sw].y, depthPoints[sw].z));

          model.addFace(new UVec3(depthPoints[ne].x, depthPoints[ne].y, depthPoints[ne].z), 
          new UVec3(depthPoints[se].x, depthPoints[se].y, depthPoints[se].z ), 
          new UVec3(depthPoints[sw].x, depthPoints[sw].y, depthPoints[sw].z));
        }
      } 
      else {
        stroke(255);
        PVector currentPoint = depthPoints[i];
        if (currentPoint.z < maxZ) {
          point(currentPoint.x, currentPoint.y, currentPoint.z);
        }
      }
    }
  }


  if (scanning) {
    model.calcBounds();
    model.translate(0, 0, -maxZ);

    float modelWidth = (model.bb.max.x - model.bb.min.x);
    float modelHeight = (model.bb.max.y - model.bb.min.y);

    UGeometry backing = Primitive.box(modelWidth/2, modelHeight/2, 10);
    model.add(backing);
    
    model.scale(0.01);
    model.rotateY(radians(180));
    model.toOrigin();
    
    model.endShape();
    model.writeSTL(this, "scan_"+random(1000)+".stl");
    scanning = false;
  }
}


boolean allZero(PVector p) {
  return (p.x == 0 && p.y == 0 && p.z == 0);
}

void keyPressed() {
  println(maxZ);
  if (keyCode == UP) {
    maxZ += 100;
  }
  if (keyCode == DOWN) {
    maxZ -= 100;
  }
  if (key == ' ') {
    scanning = true;
    model.reset();
  }
}

