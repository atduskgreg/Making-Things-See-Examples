import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI  kinect;

SkeletonRecorder recorder;

boolean recording = false;
boolean playing = false;

float offByDistance = 0.0;
    PFont font;

void setup() {
  size(1028, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);

  // initialize our recorder and
  // tell it to track left hand
  // it takes an array because it can track multiple joints
  int[] jointsToTrack = {SimpleOpenNI.SKEL_LEFT_HAND};
  recorder = new SkeletonRecorder(kinect, jointsToTrack);
  
          font = createFont("Verdana", 40);
        textFont(font);
}

void draw() {
  background(0);
  kinect.update();
  // display text information
  pushMatrix();
//    scale(4);

    fill(255);
    translate(0, 50, 0);
    text("totalFrames: " + recorder.frames.size(), 5, 0);
    text("recording: " + recording, 5, 50);
    text("currentFrame: " + recorder.currentFrame, 5, 100 );
    float c = map(offByDistance, 0, 1000, 0, 255);
    fill(c, 255-c, 0);
    text("off by: " + offByDistance, 5, 150);
  popMatrix();

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
      
      pushMatrix();
        stroke(255, 0, 0);
        strokeWeight(50);
        point(currentPosition.x, currentPosition.y, currentPosition.z);  
      popMatrix();

      // if we're recording
      // tell the record to capture this frame
      if (recording) {
        recorder.recordFrame();
      }
      else if (playing) {
        // if we're playing
        // access the recorded joint position
        PVector recordedPosition = recorder.trackedJoints[0].getPosition().position;

        // display the recorded joint position
        pushMatrix();
          stroke(0, 255, 0);
          strokeWeight(30);
          point(recordedPosition.x, recordedPosition.y, recordedPosition.z);  
        popMatrix();

        // draw a line between the current position and the recorded one
        // set its color based on the distance between the two
        stroke(c, 255-c, 0);
        strokeWeight(20);
        line(currentPosition.x, currentPosition.y, currentPosition.z, recordedPosition.x, recordedPosition.y, recordedPosition.z);
        // calculate the vector between the current and recorded positions
        // with vector subtraction
        currentPosition.sub(recordedPosition);
        // store the magnitude of that vector as the off-by distance
        // for display
        offByDistance = currentPosition.mag();
        // tell the recorder to load up
        // the next frame
        recorder.nextFrame();
      }
      
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    recording = !recording;
    playing = !playing;
  }
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

