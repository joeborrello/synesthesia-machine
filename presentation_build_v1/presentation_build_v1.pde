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

void setup() {
  size(513, 768, P3D);
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  song = minim.loadFile("Mr-Scruff_Get-On-Down.mp3", 1024);
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
  
  for(int i = 0; i < fft.specSize(); i++)
  //for(int i = 0; i < 3; i++)
  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    //line( i*(width/513.), height, i*(width/513.), height - fft.getBand(i)*8 );
    line(i, height, i, height - fft.getBand(i)*8*(i/6+1));
    //line(i, height, i, height - fft.getBand(i)*8);
    stroke(255, 255-i, i);
  }
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
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
  
