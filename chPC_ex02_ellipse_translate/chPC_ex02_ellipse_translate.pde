void setup(){
  size(640, 480, P3D);
}

void draw(){
  background(0);
  
  // translate moves the position from which we draw
  // 100 in the third argument moves to z = 100
  translate(0,0,100);
  ellipse(width/2, height/2, 100, 100);
}
