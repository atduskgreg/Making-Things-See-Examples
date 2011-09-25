import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI  kinect;

boolean tracking = false;
int userID;
int[] userMap;
// declare our background
PImage backgroundImage;

void setup() {
  size(640, 480, OPENGL);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  // enable color image from the Kinect
  kinect.enableRGB();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);
  // turn on depth-color alignment
  kinect.alternativeViewPointDepthToImage();
  // load the background image
  backgroundImage = loadImage("empire_state.jpg");
}

void draw() {
  // display the background image
  image(backgroundImage, 0, 0);
  kinect.update();
  if (tracking) {
    // get the Kinect color image
    PImage rgbImage = kinect.rgbImage();
    // prepare the color pixels
    rgbImage.loadPixels();
    loadPixels();

    userMap = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);
    for (int i =0; i < userMap.length; i++) {
      // if the pixel is part of the user
      if (userMap[i] != 0) {
        // set the sketch pixel to the color pixel
        pixels[i] = rgbImage.pixels[i];
      }
    }
    updatePixels();
  }
}

void onNewUser(int uID) {
  userID = uID;
  tracking = true;
  println("tracking");
}