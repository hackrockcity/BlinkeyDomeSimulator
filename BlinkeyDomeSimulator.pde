import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;
import hypermedia.net.*;
import java.util.concurrent.*;


int DOME_RADIUS = 12;
int strips = 40;               // Number of strips around the circumference of the sphere
int lights_per_strip = 32*5;    // Number of lights along the strip
int packet_length = strips*lights_per_strip*3 + 1;

Boolean demoMode = true;
BlockingQueue newImageQueue;
color[][] frameBuffer;

DemoTransmitter demoTransmitter;
UDP udp;
PeasyCam pCamera;
BlinkeyLights blinkeyLights;
Dome dome;
Hud hud;
ImageHud imageHud;

PFont font;
PImage groundTexture;

void setup() {
  size(512, 425, P3D);
  colorMode(RGB,255);
  frameRate(60);

  pCamera = new PeasyCam(this, 0, -50, 0, 100);
  pCamera.setMinimumDistance(.2);
  pCamera.setMaximumDistance(150*10);
  pCamera.setSuppressRollRotationMode();
  pCamera.rotateX(-.4);

  pCamera.setWheelScale(0.05);

  newImageQueue = new ArrayBlockingQueue(2);

  udp = new UDP( this, 58082 );
  udp.listen( true );

  font = loadFont("Serif-24.vlw"); 
  hud = new Hud();
  dome = new Dome(DOME_RADIUS);
  blinkeyLights = new BlinkeyLights(DOME_RADIUS, strips, lights_per_strip);
  imageHud = new ImageHud(20, height-160-20, strips, lights_per_strip);

  groundTexture = loadImage("Lost Lake.jpg");

  demoTransmitter = new DemoTransmitter();
  demoTransmitter.start();
}

int animationStep = 0;

int maxConvertedByte = 0;

int convertByte(byte b) {
  int c = (b<0) ? 256+b : b;

  if (c > maxConvertedByte) {
    maxConvertedByte = c;
    println("Max Converted Byte is now " + c);
  }  
  
  return c;
}

void receive(byte[] data, String ip, int port) {  
  if (demoMode) {
    println("Started receiving data from " + ip + ". Demo mode disabled.");
    demoMode = false;
  }
  
  if (data[0] == 2) {
    // We got a new mode, so copy it out
    String modeName = new String(data);
    hud.setHudText(modeName);
    return;
  }

  if (data[0] != 1) {
    println("Packet header mismatch. Expected 1, got " + data[0]);
    return;
  }

  if (data.length != packet_length) {
    println("Packet size mismatch. Expected "+packet_length+", got " + data.length);
    return;
  }

  if (newImageQueue.size() > 0) {
    //println("Buffer full, dropping frame!");
    return;
  }

  color[] newImage = new color[strips*lights_per_strip];

  for (int i=0; i< strips*lights_per_strip; i++) {
      // Processing doesn't like it when you call the color function while in an event
      // go figure
      newImage[i] = (int)(0xff<<24 | convertByte(data[i*3 + 1])<<16) |
            (convertByte(data[i*3 + 2])<<8) |
            (convertByte(data[i*3 + 3]));
  }
  try { 
    newImageQueue.put(newImage);
  } 
  catch( InterruptedException e ) {
    println("Interrupted Exception caught");
  }  
}

void drawGround() {
  stroke(92, 51);
  fill(92, 51);
  
  int tilefactor = 10;
  float bound = DOME_RADIUS*10*4;

  for (int x = 0; x < tilefactor; x++) {
    for (int y = 0; y < tilefactor; y++) {
      pushMatrix();
      translate(0, 0.5, 0);
      
      translate(bound/tilefactor*x-bound/2, 0, bound/tilefactor*y-bound/2);
      
      beginShape();
      texture(groundTexture);
      textureMode(NORMAL);
      
      vertex(0,                .5, 0,                0, 0);
      vertex(bound/tilefactor, .5, 0,                1, 0);
      vertex(bound/tilefactor, .5, bound/tilefactor, 1, 1);
      vertex(0,                .5, bound/tilefactor, 0, 1);
      endShape();
      popMatrix();
    }
  }
}

void drawFPS() {
  pCamera.beginHUD();
  noLights();
  fill(255, 255, 255);
  textFont(font);
  textAlign(CENTER);
  text(int(frameRate), width - 50, height - 50);
  pCamera.endHUD();
}

void draw() {
  background(0);
  lights();

  drawGround();

  dome.draw();
  blinkeyLights.draw();

  hud.draw();
  imageHud.draw();

  drawFPS();
  
  if (newImageQueue.size() > 0) {
    color[] newImage = (color[])newImageQueue.remove();
    blinkeyLights.update(newImage);
    imageHud.update(newImage);
  }
}