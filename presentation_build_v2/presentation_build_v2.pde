import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;
FFT fft;

int ledPin = 12;
int ledPin2 = 8;
int ledPin3 = 2;

float angle;

void setup() {
  size(1000 , 1000, P3D);
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  song = minim.loadFile("Exhale.aiff", 1024);
  song.play();
   
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(500);
  
  bl = new BeatListener(beat, song);
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  arduino.pinMode(ledPin, Arduino.OUTPUT);
  arduino.pinMode(ledPin2, Arduino.OUTPUT);
  arduino.pinMode(ledPin3, Arduino.OUTPUT);
}

void draw() {
  background(0);
  fill(255);
  fft.forward(song.mix);
  if(beat.isKick()){
    arduino.digitalWrite(ledPin, Arduino.HIGH);
  }
  if(beat.isSnare()){
    arduino.digitalWrite(ledPin2, Arduino.HIGH);
  }
  if(beat.isHat()){
    arduino.digitalWrite(ledPin3, Arduino.HIGH);
  }
  arduino.digitalWrite(ledPin, Arduino.LOW);
  arduino.digitalWrite(ledPin2, Arduino.LOW);
  arduino.digitalWrite(ledPin3, Arduino.LOW);
  
  beginShape();
  for(int i = 0; i < fft.specSize(); i++)
  //for(int i = 0; i < 3; i++)
  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    line( i*(width/513.), height, i*(width/513.), height - fft.getBand(i)*8 );
    stroke(255, 255-i, i);
    line(i, height, i, i, height - fft.getBand(i)*8*(i/6+1), i);
    stroke(255);
    //line(i, height, i, height - fft.getBand(i)*8);
    stroke(255, 255-i, i);
  }
  endShape();
  
  
  /*
  line(3,0,3,height);
  stroke(255);
  line(4,0,4,height);
  stroke(255);
  line(5,0,5,height);
  stroke(255);
  
  line(21,0,21,height);
  stroke(255);
  line(22,0,22,height);
  stroke(255);
  line(130,0,130,height);
  stroke(255);
  line(131,0,131,height);
  */
  
  // Center geometry in display windwow.
  // you can changlee 3rd argument ('0')
  // to move block group closer(+) / further(-)
  translate(width/2, height/2, -200 + mouseX * 0.65);

  // Rotate around y and x axes
  rotateY(radians(angle));
  rotateX(radians(angle));
  
  angle += 0.2;
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
  
