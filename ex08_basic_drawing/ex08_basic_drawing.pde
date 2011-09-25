import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;

// declare global variables for the
// previous x and y coordinates
int previousX;
int previousY;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();   
}

void draw()
{
  closestValue = 8000;
  
  kinect.update();

  int[] depthValues = kinect.depthMap();
  
    for(int y = 0; y < 480; y++){
      for(int x = 0; x < 640; x++){
        int i = x + y * 640;
        int currentDepthValue = depthValues[i];
      
        if(currentDepthValue > 0 && currentDepthValue < closestValue){

          closestValue = currentDepthValue;
          closestX = x;
          closestY = y;
        }
      }
    }
        
  image(kinect.depthImage(),0,0);

  // set the line drawing color to red
  stroke(255,0,0);
  
  // draw a line from the previous point
  // to the new closest one
  line(previousX, previousY, closestX, closestY);
  
  // save the closest point
  // as the new previous one
  previousX = closestX;
  previousY = closestY;
  

}

void mousePressed(){
 background(0);
}
