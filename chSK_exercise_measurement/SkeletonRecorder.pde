class SkeletonRecorder {
  private SimpleOpenNI context;
  TrackedJoint[] trackedJoints;
  int userID;
  int currentFrame = 0;
  int[] jointIDsToTrack;

  SkeletonRecorder(SimpleOpenNI context, int[] jointIDsToTrack) {
    this.context = context;
    this.userID = userID;
    this.jointIDsToTrack = jointIDsToTrack;
  }

  void setUser(int userID) {
      this.userID = userID;
      trackedJoints = new TrackedJoint[jointIDsToTrack.length];

      for (int i = 0; i < trackedJoints.length; i++) {
        trackedJoints[i] = new TrackedJoint(this, context, userID, jointIDsToTrack[i]);
      }
  }

  void recordFrame() {
    for (int i = 0; i < trackedJoints.length; i++) {
      trackedJoints[i].recordFrame();
    }
  }

  void nextFrame() {
    currentFrame++;
    if (currentFrame == totalFrames) {
      currentFrame = 0;
    }
  }
}

class TrackedJoint {
  int jointID;
  SimpleOpenNI context;
  ArrayList frames;
  int userID;
  SkeletonRecorder recorder;

  TrackedJoint(SkeletonRecorder recorder, SimpleOpenNI context, int userID, int jointID ) {
    this.recorder = recorder;
    this.context = context;
    this.userID = userID;
    this.jointID = jointID;

    frames = new ArrayList();
  }

  JointPosition getPosition() {
    return getPositionAtFrame(recorder.currentFrame);
  }

  JointPosition getPositionAtFrame(int frameNum) {
    return (JointPosition) frames.get(frameNum);
  }

  void recordFrame() {
    PVector position = new PVector();
    float confidence = context.getJointPositionSkeleton(userID, jointID, position);
    JointPosition frame = new JointPosition(position, confidence)
    frames.add(frame);
  }
}


class JointPosition{
    PVector position;
    float confidence
    
    JointFrame(PVector position, float confidence){
        this.position = position;
        this.confidence = confidence;
    }
}