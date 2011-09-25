import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;

float lastX;
float lastY;

// declare x-y coordinates
// for the image
float image1X;
float image1Y;
// declare a boolean to
// store whether or not the
// image is moving
boolean imageMoving;
// declare a variable
// to store the image
PImage image1;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();   
 
  // start the image out moving
  // so mouse press will drop it
  imageMoving = true;
 
  // load the image from a file
  image1 = loadImage("image1.jpg");
  
  background(0); 
}

void draw()
{
  closestValue = 8000;
  
  kinect.update();

  int[] depthValues = kinect.depthMap();
  
    for(int y = 0; y < 480; y++){
      for(int x = 0; x < 640; x++){

        int reversedX = 640-x-1;        
        int i = reversedX + y * 640;
        int currentDepthValue = depthValues[i];
      
        if(currentDepthValue > 610 && currentDepthValue < 1525 && currentDepthValue < closestValue){

          closestValue = currentDepthValue;
          closestX = x;
          closestY = y;
        }
      }
    }

   float interpolatedX = lerp(lastX, closestX, 0.3);   
   float interpolatedY = lerp(lastY, closestY, 0.3);

   // clear the previous drawing
   background(0);
   
   // only update image position
   // if image is in moving state
   if(imageMoving){
       image1X = interpolatedX;
       image1Y = interpolatedY; 
   }
   
   //draw the image on the screen
   image(image1,image1X,image1Y);

   lastX = interpolatedX;
   lastY = interpolatedY;
}

void mousePressed(){
   // if the image is moving, drop it
   // if the image is dropped, pick it up    
   imageMoving = !imageMoving;
}
