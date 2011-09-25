class SkeletonRecorder {
  SimpleOpenNI context;
  int jointID;
  int userID;
  ArrayList frames;
  int currentFrame = 0;

  SkeletonRecorder(SimpleOpenNI context, int jointID ) {
    this.context = context;
    this.jointID = jointID;
    frames = new ArrayList();
  }
  
  void setUser(int userID) {
    this.userID = userID;  
  }

  void nextFrame() {
    currentFrame++;
    if (currentFrame == frames.size()) {
      currentFrame = 0;
    }
  }
  
  PVector getPosition() {
    return (PVector)frames.get(currentFrame);
  }

  void recordFrame() {
    PVector position = new PVector();
    context.getJointPositionSkeleton(userID, jointID, position);
    frames.add(position);
  }
}