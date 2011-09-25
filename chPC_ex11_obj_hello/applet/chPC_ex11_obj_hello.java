import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 
import saito.objloader.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class chPC_ex11_obj_hello extends PApplet {




// declare an OBJModel object
OBJModel model;

float rotateX;
float rotateY;

public void setup() {
  size(640, 480, OPENGL);

  // load the model file
  // use triangles as the basic geometry
  model = new OBJModel(this, "kinect.obj", "relative", TRIANGLES);
  
  // tell the model to translate itself
  // to be centered at 0,0
  model.translateToCenter();
  noStroke();
}

public void draw() {
  background(255);
  
  // turn on the lights
  lights();

  translate(width/2, height/2, 0);

  rotateX(rotateY);
  rotateY(rotateX);
  
  // tell the model to draw itself
  model.draw();
}    

public void mouseDragged() {
  rotateX += (mouseX - pmouseX) * 0.01f;
  rotateY -= (mouseY - pmouseY) * 0.01f;
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#c0c0c0", "chPC_ex11_obj_hello" });
  }
}
