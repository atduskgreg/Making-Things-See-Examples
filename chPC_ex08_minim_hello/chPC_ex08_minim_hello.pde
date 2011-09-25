import ddf.minim.*;

Minim minim;
AudioPlayer player;

void setup() {
  minim = new Minim(this);
  player = minim.loadFile("kick.wav");
  player.play();
}

void draw() {
}

void stop()
{
  player.close();
  minim.stop();

  super.stop();
}

