import SimpleOpenNI.*;
// import and declarations for minim:
import ddf.minim.*;
Minim minim;
AudioPlayer player;
// declare our poser object
SkeletonPoser pose;

SimpleOpenNI  kinect;

void setup() {
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true);
  
  // initialize the minim object
  minim = new Minim(this);
  // and load the stayin alive mp3 file
  player = minim.loadFile("stayin_alive.mp3");
  
  // initialize the pose object
  pose = new SkeletonPoser(kinect);
  // rules for the right arm
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.ABOVE, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_ELBOW, PoseRule.ABOVE, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_ELBOW, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  // rules for the left arm
  pose.addRule(SimpleOpenNI.SKEL_LEFT_ELBOW, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_ELBOW, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_ELBOW);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_ELBOW);
  // rules for the right leg
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_KNEE, PoseRule.BELOW, SimpleOpenNI.SKEL_RIGHT_HIP);
  pose.addRule(SimpleOpenNI.SKEL_RIGHT_KNEE, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_HIP);
  // rules for the left leg
  pose.addRule(SimpleOpenNI.SKEL_LEFT_KNEE, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_HIP);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_KNEE, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_HIP);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_KNEE);
  pose.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_KNEE);  
  strokeWeight(5);
}

void draw() {
  background(0);
  kinect.update();
  image(kinect.depthImage(), 0, 0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    if( kinect.isTrackingSkeleton(userId)) {

      // check to see if the user
      // is in the pose
      if(pose.check(userId)){
        //if they are, set the color white
         stroke(255);
         // and start the song playing
         if(!player.isPlaying(){
           player.play();
         }
       } else {
         // otherwise set the color to red
         // and don't start the song
         stroke(255,0,0);
       }
       // draw the skeleton in whatever color we chose
       drawSkeleton(userId);
    }
  }
}

void drawSkeleton(int userId) {
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawLimb(int userId, int jointType1, int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  // draw the joint position
  confidence = kinect.getJointPositionSkeleton(userId, jointType1, jointPos1);
  confidence = kinect.getJointPositionSkeleton(userId, jointType2, jointPos2);

  line(jointPos1.x, jointPos1.y, jointPos1.z, 
  jointPos2.x, jointPos2.y, jointPos2.z);
}

void keyPressed(){
  saveFrame("stayin_alive_"+random(100)+".png");
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

