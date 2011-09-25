import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;
int[] sceneMap;
PImage depthImage;

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
  image(kinect.depthImage(), 0, 0);
  loadPixels();
  // scene map is an array of ints
  // just like the user map
  sceneMap = kinect.sceneMap();
  for (int i =0; i < sceneMap.length; i++) {
    // each distinct value in the map
    // indicates a different object, wall, or person
    if(sceneMap[i] == 1){
      pixels[i] = color(0, 255, 0);
    }
    if(sceneMap[i] == 2){
        pixels[i] = color(255, 0, 0);
    }
    if(sceneMap[i] == 3){
        pixels[i] = color(0, 0, 255);
    } 
    if(sceneMap[i] == 4){
        pixels[i] = color(255, 255, 0);
    }
     if(sceneMap[i] == 5){
        pixels[i] = color(0,255,255);
    }
    if(sceneMap[i] == 6){
        pixels[i] = color(255,0,255);
    }
  }
  updatePixels();
}

void keyPressed(){
  saveFrame("scene_image.png");
}
