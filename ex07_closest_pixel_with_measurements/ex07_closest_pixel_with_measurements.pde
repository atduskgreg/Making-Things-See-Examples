import SimpleOpenNI.*;
SimpleOpenNI  kinect;

float brightestValue;
int brightestX;
int brightestY;


void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();    
}

void draw()
{
  brightestValue = 0;
  kinect.update();

  int[] depthValues = kinect.depthMap();
    for(int x = 0; x < 640; x++){
      for(int y = 0; y < 480; y++){
        int i = x + y * 640;
      
        int currentDepthValue = depthValues[i];
      
        if(currentDepthValue > brightestValue){
          brightestValue = currentDepthValue;
          brightestX = x;
          brightestY = y;
        }
      }
    }
  
  image(kinect.depthImage(),0,0);

  float closestValueInInches = brightestValue / 25.4;
  println("in: " + closestValueInInches);

  fill(255,0,0);
  ellipse(brightestX, brightestY, 25, 25);
}

