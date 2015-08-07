import ddf.minim.*;
import ddf.minim.analysis.*;
import com.google.common.collect.EvictingQueue;

Minim minim;
AudioPlayer player;
BeatDetect beat;

float[] beatTrackers;
EvictingQueue<float[]> history;
int SIZE = 5;

void setup() {
  size(600, 600, P3D);
  
  minim = new Minim(this);
  player = minim.loadFile("reverie.mp3");
  player.play();
  beat = new BeatDetect();
  beat.detectMode(BeatDetect.FREQ_ENERGY);
  beat.setSensitivity(50);
 
  beatTrackers = new float[beat.dectectSize()];
  history = EvictingQueue.create(60);

  ellipseMode(RADIUS);
}

void draw() {
  background(0);
  fill(255);
  noStroke();
  beat.detect(player.mix);
  
  // Calculate current state
  for (int i = 0; i < beatTrackers.length; i++) {
    beatTrackers[i] *= 0.5;
    if (beat.isRange(i, i, 1)) {
      beatTrackers[i] = SIZE;
    }
  }
  
  
  // Calculate history
  history.offer(beatTrackers.clone());
  
  int column = 0;
  for (float[] slice : history) {
    for (int i = 0; i < slice.length; i++) {
      ellipse(column * (SIZE + 5), i * (SIZE + 5), slice[i], slice[i]);
    }
    column++;
  }
}