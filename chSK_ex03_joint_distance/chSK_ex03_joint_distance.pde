import SimpleOpenNI.*;
SimpleOpenNI  kinect;

void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  size(640, 480);
  stroke(255,0,0);
  strokeWeight(5);
}

void draw() {
  kinect.update();
  image(kinect.depthImage(), 0, 0);
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {      
      PVector leftHand = new PVector();
      PVector rightHand = new PVector();
    
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);      
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
      
      // calculate difference by subtracting one vector from another
      PVector differenceVector = PVector.sub(leftHand, rightHand);
      // calculate the distance and direction
      // of the difference vector
      float magnitude = differenceVector.mag();
      differenceVector.normalize();
      // draw a line between the two handsst
      kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HAND, SimpleOpenNI.SKEL_RIGHT_HAND);
      // display
      pushMatrix();
        scale(4);
        fill(differenceVector.x * 255, differenceVector.y * 255, differenceVector.z * 255);
        text("m: " + magnitude, 5, 10);
      popMatrix();
    }
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