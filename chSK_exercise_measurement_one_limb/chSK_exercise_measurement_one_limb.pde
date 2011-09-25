import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI  kinect;

SkeletonRecorder recorder;
boolean recording = false;
float offByDistance = 0.0;

void setup() {
  size(1028, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  // initialize our recorder and
  // tell it to track left hand
  recorder = new SkeletonRecorder(kinect, SimpleOpenNI.SKEL_LEFT_HAND);
  // load a font
  PFont font = createFont("Verdana", 40);
  textFont(font);
}

void draw() {
  background(0);
  kinect.update();
  // these are to make our spheres look nice
  lights();
  noStroke();
  // create heads-up display
  fill(255);
  text("totalFrames: " + recorder.frames.size(), 5, 50);
  text("recording: " + recording, 5, 100);
  text("currentFrame: " + recorder.currentFrame, 5, 150 );
  // set text color as a gradient from red to green
  // based on distance between hands
  float c = map(offByDistance, 0, 1000, 0, 255);
  fill(c, 255-c, 0);
  text("off by: " + offByDistance, 5, 200);

  translate(width/2, height/2, 0);
  rotateX(radians(180));

  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    recorder.setUser(userId);
    if ( kinect.isTrackingSkeleton(userId)) {
      PVector currentPosition = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, currentPosition);
      // display the sphere for the current limb position
      pushMatrix();
        fill(255,0,0);
        translate(currentPosition.x, currentPosition.y, currentPosition.z);  
        sphere(80);
      popMatrix();
      // if we're recording tell the recorder to capture this frame
      if (recording) {
        recorder.recordFrame();
      }
      else  {
        // if we're playing access the recorded joint position
        PVector recordedPosition = recorder.getPosition();
        // display the recorded joint position
        pushMatrix();
          fill(0, 255, 0);
          translate(recordedPosition.x, recordedPosition.y, recordedPosition.z);  
          sphere(80);
        popMatrix();
        // draw a line between the current position and the recorded one
        // set its color based on the distance between the two
        stroke(c, 255-c, 0);
        strokeWeight(20);
        line(currentPosition.x, currentPosition.y, currentPosition.z, recordedPosition.x, recordedPosition.y, recordedPosition.z);
        // calculate the vector between the current and recorded positions
        // with vector subtraction
        currentPosition.sub(recordedPosition);
        // store the magnitude of that vector as the off-by distance for display
        offByDistance = currentPosition.mag();
        // tell the recorder to load up the next frame
        recorder.nextFrame();
      }
    }
  }
}

void keyPressed() {
  recording = false;
}

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
    recording = true;
  } 
  else { 
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}

