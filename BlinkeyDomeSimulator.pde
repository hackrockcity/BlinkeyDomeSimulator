import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import damkjer.ocd.*;
import processing.opengl.*;

int PIXELS_PER_FOOT = 10;
int DOME_RADIUS = 80;
float rho = DOME_RADIUS;
float factor = TWO_PI / 20.0;
float x, y, z;


//Camera cam;
PeasyCam pCamera;


ArrayList<BlinkeyLight> blinkeyLights;

void setup() {
  size(1024,1024,OPENGL);
  pCamera = new PeasyCam(this, 150);
  pCamera.setMinimumDistance(150*1);
  pCamera.setMaximumDistance(150*10);

  blinkeyLights = new ArrayList<BlinkeyLight>();
  
  int strips = 25;               // Number of strips around the circumference of the sphere
  int lights_per_strip = 45*3;    // Number of lights along the strip
  int r = 78;                  // Radius

  for (int strip = 0; strip < strips; strip++) {  
    for (int light = 0; light < lights_per_strip; light++) {

      float inclination = HALF_PI + (HALF_PI)*((float)light/lights_per_strip);
      float azimuth     = (2*PI)*((float)strip/strips);
    
      float x = r * cos(azimuth) * sin(inclination);
      float z = r * sin(azimuth) * sin(inclination);
      float y = r *                cos(inclination);


    
      blinkeyLights.add(new BlinkeyLight(x,y,z));
      
     // print("inc= " + inclination + ", azi=" + azimuth + "\n");
      print(x + ", " + y + ", " + z + "\n");
    }
  }
}

int animationStep = 0;

void draw() {
  background(0);
  
  //cam.feed();
  stroke(255,100,100);
  fill(200,50,50);
  lights();
  //translate(width/2, height/2, 0);
  
  // Sphere is messed up. This is a workaround See:
  // http://forum.processing.org/topic/3d-sphere-issue
//  pushMatrix();
//  scale(PIXELS_PER_FOOT * 16);
//  sphere(1);  
//  popMatrix();

//  for(float phi = 0.0; phi < HALF_PI; phi += factor) {
//    beginShape(QUAD_STRIP);
//    for(float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
//      x = rho * sin(phi) * cos(theta);
//      z = rho * sin(phi) * sin(theta);
//      y = -rho * cos(phi);
//      
//      vertex(x, y, z);
//      
//      x = rho * sin(phi + factor) * cos(theta);
//      z = rho * sin(phi + factor) * sin(theta);
//      y = -rho * cos(phi + factor);
//      
//      vertex(x, y, z);
//    }
//    endShape(CLOSE);
//  }

  stroke(100,255,100);
  fill(50,200,50);
  //box(PIXELS_PER_FOOT * 32, 1, PIXELS_PER_FOOT * 32);
  
  if (keyPressed) {
    if (key == 'w') {
      //cam.dolly(-1);
    }
    else if (key == 's') {
      //cam.dolly(1);
    }
    else if (key == 'a') {
      //cam.truck(-1);
    }
    else if (key == 'd') {
      //cam.truck(1);
    }
  }
  
  // Blink the lights
  for (int i = 0; i < blinkeyLights.size(); i++) {
   if (animationStep == i) {
     blinkeyLights.get(i).setColor(color(255,255,255));
   }
   else {
     blinkeyLights.get(i).setColor(color(0,0,255));    
   }
  }
  animationStep = (animationStep+1)%blinkeyLights.size();
  
  // Draw the lights
  for (int i = 0; i < blinkeyLights.size(); i++) { 
    BlinkeyLight light = blinkeyLights.get(i);
    light.draw();
  }
}

void mouseMoved() {
  //cam.pan(radians(mouseX - pmouseX) / 10.0);
  //cam.tilt(radians(mouseY - pmouseY) / 10.0);
}
