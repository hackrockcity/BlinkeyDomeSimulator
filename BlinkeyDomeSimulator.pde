import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;

int DOME_RADIUS = 8;

int strips = 25;               // Number of strips around the circumference of the sphere
int lights_per_strip = 45*3;    // Number of lights along the strip

PeasyCam pCamera;

BlinkeyLights blinkeyLights;

Dome dome;

PFont font;

void setup() {
  size(1024, 1024, OPENGL);
  pCamera = new PeasyCam(this, 0, 0, 10, 200);
  pCamera.setMinimumDistance(1);
  pCamera.setMaximumDistance(150*10);
  pCamera.setSuppressRollRotationMode();
  pCamera.rotateX(0.2);
  pCamera.lookAt(0, -10, -20);
  pCamera.setWheelScale(0.05);

  dome = new Dome(DOME_RADIUS);
  
  font = loadFont("Serif-24.vlw"); 

  blinkeyLights = new BlinkeyLights(DOME_RADIUS, strips, lights_per_strip);
}

int animationStep = 0;

void updateLights() {
  // Blink the lights
  for (int i = 0; i < blinkeyLights.size(); i++) {
    if (animationStep == i) {
      blinkeyLights.get(i).setColor(color(255, 255, 255));
    }
    else {
      blinkeyLights.get(i).setColor(color(0, 0, 255));
    }
  }
  animationStep = (animationStep+1)%blinkeyLights.size();
}

void draw() {
  updateLights();

  background(0);
  lights();
  dome.draw();
  blinkeyLights.draw();
  
  pCamera.beginHUD();
    noLights();
    fill(255,255,255,200);
    rect(10,10,width-20,30);
    textFont(font); 
    fill(0,0,0);
    textAlign(CENTER);
    text("Dome Shit", width/2-20, 32);
    
    fill(255,255,255,200);
    ellipseMode(CENTER);
    ellipse(120, height/2+225, 200,200);
  pCamera.endHUD();
  
  

 
  

}

