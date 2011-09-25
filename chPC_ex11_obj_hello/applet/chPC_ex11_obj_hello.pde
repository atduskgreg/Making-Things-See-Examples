import processing.opengl.*;
import saito.objloader.*;

// declare an OBJModel object
OBJModel model;

float rotateX;
float rotateY;

void setup() {
  size(640, 480, OPENGL);

  // load the model file
  // use triangles as the basic geometry
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  
  // tell the model to translate itself
  // to be centered at 0,0
  model.translateToCenter();
  noStroke();
}

void draw() {
  background(255);
  
  // turn on the lights
  lights();

  translate(width/2, height/2, 0);

  rotateX(rotateY);
  rotateY(rotateX);
  
  // tell the model to draw itself
  model.draw();
}    

void mouseDragged() {
  rotateX += (mouseX - pmouseX) * 0.01;
  rotateY -= (mouseY - pmouseY) * 0.01;
}
