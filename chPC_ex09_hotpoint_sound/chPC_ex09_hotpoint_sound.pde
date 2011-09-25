import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

// minim objects
Minim minim;
AudioPlayer player;

SimpleOpenNI kinect;

float rotation = 0;

// used for edge detection
boolean wasJustInBox = false;

int boxSize = 150;
PVector boxCenter = new PVector(0, 0, 600);

float s = 1;

void setup() {
  size(1024, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();

  // initialize Minim
  // and AudioPlayer
  minim = new Minim(this);
  player = minim.loadFile("kick.wav");
}

void draw() {
  background(0);
  kinect.update();

  translate(width/2, height/2, -1000);
  rotateX(radians(180));

  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));

  translate(0, 0, s*-1000);
  scale(s);

  stroke(255);

  PVector[] depthPoints = kinect.depthMapRealWorld();
  int depthPointsInBox = 0;

  for (int i = 0; i < depthPoints.length; i+=10) {
    PVector currentPoint = depthPoints[i];

    if (currentPoint.x > boxCenter.x - boxSize/2 && currentPoint.x < boxCenter.x + boxSize/2) {
      if (currentPoint.y > boxCenter.y - boxSize/2 && currentPoint.y < boxCenter.y + boxSize/2) {
        if (currentPoint.z > boxCenter.z - boxSize/2 && currentPoint.z < boxCenter.z + boxSize/2) {
          depthPointsInBox++;
        }
      }
    }
    
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }

  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);

  // edge detection
  // are we in the box this time
  boolean isInBox = (depthPointsInBox > 0);

  // if we just moved in from outside
  // start it playing
  if (isInBox && !wasJustInBox) {
    player.play();
  } 

  // if it's played all the way through
  // pause and rewind
  if (!player.isPlaying()) {
    player.rewind();
    player.pause();
  }

  // save current status
  // for next time
  wasJustInBox = isInBox;

  translate(boxCenter.x, boxCenter.y, boxCenter.z);

  fill(255, 0, 0, boxAlpha);
  stroke(255, 0, 0);
  box(boxSize);
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

// use keys to control zoom
// up-arrow zooms in
// down arrow zooms out
// s gets passed to scale() in draw()
void keyPressed() {
  if (keyCode == 38) {
    s = s + 0.01;
  }
  if (keyCode == 40) {
    s = s - 0.01;
  }
}

