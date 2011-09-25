import processing.opengl.*;
// import both 
import unlekker.util.*;
import unlekker.modelbuilder.*;
// declare our model object
UGeometry model;

float x = 0;

void setup() {
  size(400, 400, OPENGL);
  stroke(255, 0, 0);
  strokeWeight(3);
  fill(255);

 // initialize our model,
  model = new UGeometry();
  // set shape type to TRIANGLES
  // and begin adding geometry
  model.beginShape(TRIANGLES);
  
  // build a triangle out of three vectors
  model.addFace(
   new UVec3(150, 150, 0),
   new UVec3(300, 150, 0),
   new UVec3(150, 150, -150)
  );
  
  model.addFace(
    new UVec3(300, 150, 0),
    new UVec3(300, 150, -150),
    new UVec3(150, 150, -150)
  );
  
   model.addFace(
    new UVec3(300, 150, -150),
    new UVec3(300, 150, 0),
    new UVec3(300, 300, 0)
  );
  
  model.addFace(
    new UVec3(300, 300, -150),
    new UVec3(300, 150, -150),  
    new UVec3(300, 300, 0)
  );
  
  model.endShape();
}

void draw() {
  background(255);
  lights();

  translate(150, 150, -75);
  rotateY(x);
  x+=0.01;
  translate(-150, -150, 75);

  model.draw(this);
}

void keyPressed() {
  model.writeSTL(this, "part_cube.stl");
}

