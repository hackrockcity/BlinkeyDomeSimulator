import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;
import hypermedia.net.*;

int DOME_RADIUS = 8;
int strips = 25;               // Number of strips around the circumference of the sphere
int lights_per_strip = 45*3;    // Number of lights along the strip

Boolean demoMode = true;
Boolean newData = false;
color[] newImage;

UDP udp;

PeasyCam pCamera;
BlinkeyLights blinkeyLights;
Dome dome;
Hud hud;
ImageHud imageHud;

PFont font;
PImage groundTexture;

void setup() {
  //size(1024, 1024, OPENGL);
    size(1680, 1000, OPENGL);
  pCamera = new PeasyCam(this, 0, -30, 0, 50);
  //pCamera.setMinimumDistance(1);
//  pCamera.setMaximumDistance(150*10);
  pCamera.setSuppressRollRotationMode();
  pCamera.rotateX(-0.2);
//  pCamera.lookAt(0, -10, -20);
//  pCamera.rotateY(-HALF_PI);
  pCamera.setWheelScale(0.05);

  newImage = new color[strips*lights_per_strip];
  
  udp = new UDP( this, 58082 );
  udp.listen( true );

  font = loadFont("Serif-24.vlw"); 
  hud = new Hud();
  dome = new Dome(DOME_RADIUS);
  blinkeyLights = new BlinkeyLights(DOME_RADIUS, strips, lights_per_strip);
  imageHud = new ImageHud(10,10, strips, lights_per_strip);
  
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
  
  if (data[0] == 1) {
    if (data.length != strips*lights_per_strip*3 + 1) {
        println("Packet size mismatch. Expected many, got " + data.length);
        return;
    }
    
    for (int i=0; i< strips*lights_per_strip; i++) {
      newImage[i] = color(convertByte(data[i*3 + 1]),
                          convertByte(data[i*3 + 2]),
                          convertByte(data[i*3 + 3]));
    }
    newData = true;
  }
  else {
    println("Packet header mismatch. Expected 1, got " + data[0]);
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
    newData = true;
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
  else if(newData) {
    blinkeyLights.update(newImage);
    imageHud.update(newImage);
    newData = false;
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

  //hud.draw();
  imageHud.draw();
}

