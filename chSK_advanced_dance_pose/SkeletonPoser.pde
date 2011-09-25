/*
pose.addRule(SimpleOpenNI.LEFT_HAND, SkeletonPoser.ABOVE, SimpleOpenNI.LEFT_ELBOW);
pose.addRule(SimpleOpenNI.LEFT_HAND, SkeletonPoser.LEFT_OF, SimpleOpenNI.LEFT_ELBOW);

if(pose.check(userId)){
 // play the song
 // with debounce
}*/

class SkeletonPoser {
  SimpleOpenNI context;
  ArrayList rules;

  
  SkeletonPoser(SimpleOpenNI context){
    this.context = context;
    rules = new ArrayList();
  }

  void addRule(int fromJoint, int jointRelation, int toJoint){
    PoseRule rule = new PoseRule(context, fromJoint, jointRelation, toJoint);
    rules.add(rule);
  }
  
  boolean check(int userID){
    boolean result = true;
    for(int i = 0; i < rules.size(); i++){
      PoseRule rule = (PoseRule)rules.get(i);
      result = result && rule.check(userID);
    }
    return result;
  }
  
}

class PoseRule {
  int fromJoint;
  int toJoint;
  PVector fromJointVector;
  PVector toJointVector;
  SimpleOpenNI context;
    
  int jointRelation; // one of:  
  static final int ABOVE     = 1;
  static final int BELOW     = 2;
  static final int LEFT_OF   = 3;
  static final int RIGHT_OF  = 4;
  
  PoseRule(SimpleOpenNI context, int fromJoint, int jointRelation, int toJoint){
    this.context = context;
    this.fromJoint = fromJoint;
    this.toJoint = toJoint;
    this.jointRelation = jointRelation;
    
    fromJointVector = new PVector();
    toJointVector = new PVector();
  }
  
  boolean check(int userID){
    
    // populate the joint vectors for the user we're checking
    context.getJointPositionSkeleton(userID, fromJoint, fromJointVector);
    context.getJointPositionSkeleton(userID, toJoint, toJointVector);
    
    boolean result;
    
    switch(jointRelation){
     case ABOVE:
       result = (fromJointVector.y > toJointVector.y);
     break;
     case BELOW:
       result = (fromJointVector.y < toJointVector.y);
     break;
     case LEFT_OF:
       result = (fromJointVector.x < toJointVector.x);
     break;
     case RIGHT_OF:
       result = (fromJointVector.x > toJointVector.x);
     break;
    }
    
    return result;
  } 
}
