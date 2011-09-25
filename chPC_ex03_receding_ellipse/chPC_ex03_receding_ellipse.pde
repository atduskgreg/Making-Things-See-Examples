int z = 200;

void setup(){
  size(640, 480, P3D);
}

void draw(){
  background(0);
  
  // move to a further away z each time
  translate(0,0,z);
  ellipse(width/2, height/2, 100, 100);
  
  z = z - 1;
}
