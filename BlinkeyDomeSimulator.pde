import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;
//import javax.media.opengl.GL;
import hypermedia.net.*;

import java.util.concurrent.*;

int DOME_RADIUS = 8;
int strips = 25;               // Number of strips around the circumference of the sphere
int lights_per_strip = 45*3;    // Number of lights along the strip

Boolean demoMode = true;
LinkedBlockingQueue newImageQueue;

UDP udp;

PeasyCam pCamera;
BlinkeyLights blinkeyLights;
Dome dome;
Hud hud;
ImageHud imageHud;

PFont font;
PImage groundTexture;

void setup() {
  size(1024, 850, OPENGL);
  frameRate(60);
  
//  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g; //processing graphics object
//  GL gl = pgl.beginGL(); //begin opengl
//  gl.setSwapInterval(2); //set vertical sync on
//  pgl.endGL(); //end opengl
  
  //size(1680, 1000, OPENGL);
  pCamera = new PeasyCam(this, 0, 0, 10, 200);
  pCamera.setMinimumDistance(1);
  pCamera.setMaximumDistance(150*10);
  pCamera.setSuppressRollRotationMode();
  pCamera.rotateX(-0.2);
  //  pCamera.lookAt(0, -10, -20);
  //  pCamera.rotateY(-HALF_PI);
  pCamera.setWheelScale(0.05);

  newImageQueue = new LinkedBlockingQueue();

  udp = new UDP( this, 58082 );
  udp.listen( true );

  font = loadFont("Serif-24.vlw"); 
  hud = new Hud();
  dome = new Dome(DOME_RADIUS);
  blinkeyLights = new BlinkeyLights(DOME_RADIUS, strips, lights_per_strip);
  imageHud = new ImageHud(20, height-135-20, strips, lights_per_strip);

  groundTexture = loadImage("Lost Lake.jpg");
}

int animationStep = 0;

int convertByte(byte b) {
  return (b<0) ? 256+b : b;
}

void receive(byte[] data, String ip, int port) {  
  //println(" new datas!");
  if (demoMode) {
    println("Started receiving data from " + ip + ". Demo mode disabled.");
    demoMode = false;
  }

  if (data[0] != 1) {
    println("Packet header mismatch. Expected 1, got " + data[0]);
    return;
  }

  if (data.length != strips*lights_per_strip*3 + 1) {
    println("Packet size mismatch. Expected many, got " + data.length);
    return;
  }

  if (newImageQueue.size() > 0) {
    println("Buffer full, dropping frame!");
    return;
  }

  color[] newImage = new color[strips*lights_per_strip];
  
  for (int i=0; i< strips*lights_per_strip; i++) {
    newImage[i] = color(convertByte(data[i*3 + 1]), 
    convertByte(data[i*3 + 2]), 
    convertByte(data[i*3 + 3]));
  }

  try { 
    newImageQueue.put(newImage);
  } 
  catch( InterruptedException e ) {
    println("Interrupted Exception caught");
  }
}

color[] MakeDemoFrame() {
  int image_size = strips*lights_per_strip;

  color[] imageData = new color[image_size];

  for (int i = 0; i < imageData.length; i++) {
    if (animationStep == i%10) {
      imageData[i] = color(255, 255, 255);
    }
    else {
      imageData[i] = color(0, 0, 0);
    }
  }
  //animationStep = (animationStep+1)%blinkeyLights.size();
  animationStep = (animationStep + 1)%10;

  return imageData;
}

void draw() {
  if (demoMode) {
    color imageData[] = MakeDemoFrame();
    blinkeyLights.update(imageData);
    imageHud.update(imageData);
  }
  else if (newImageQueue.size() > 0) {
    color[] newImage = (color[]) newImageQueue.poll();

    blinkeyLights.update(newImage);
    imageHud.update(newImage);
  }

  background(0);
  lights();

  stroke(92, 51);
  fill(92, 51);
  pushMatrix();
  translate(0, 0.5, 0);

  beginShape();
  texture(groundTexture);
  textureMode(NORMALIZED);

  float bound = DOME_RADIUS*10*4;
  vertex(-bound, .5, -bound, 0, 0);
  vertex(bound, .5, -bound, 1, 0);
  vertex(bound, .5, bound, 1, 1);
  vertex(-bound, .5, bound, 0, 1);
  endShape();
  popMatrix();

  dome.draw();
  blinkeyLights.draw();

  hud.draw();
  imageHud.draw();
  
  pCamera.beginHUD();
    noLights();
    fill(255,255,255);
    textFont(font);
    textAlign(CENTER);
    text(int(frameRate),width - 50, height - 50);
  pCamera.endHUD();
}

