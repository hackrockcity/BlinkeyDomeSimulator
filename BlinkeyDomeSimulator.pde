import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import damkjer.ocd.*;
import processing.opengl.*;

int PIXELS_PER_FOOT = 10;
int DOME_RADIUS = 8;
float rho = DOME_RADIUS;
float factor = TWO_PI / 20.0;
float x, y, z;


//Camera cam;
PeasyCam pCamera;


void setup() {
  size(1024,1024,OPENGL);
  //cam = new Camera(this,10);
  pCamera = new PeasyCam(this, 150);
  pCamera.setMinimumDistance(150*1);
  pCamera.setMaximumDistance(150*10);

}

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

  for(float phi = 0.0; phi < HALF_PI; phi += factor) {
    beginShape(QUAD_STRIP);
    for(float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
      x = rho * sin(phi) * cos(theta);
      z = rho * sin(phi) * sin(theta);
      y = -rho * cos(phi);
      
      vertex(x, y, z);
      
      x = rho * sin(phi + factor) * cos(theta);
      z = rho * sin(phi + factor) * sin(theta);
      y = -rho * cos(phi + factor);
      
      vertex(x, y, z);
    }
    endShape(CLOSE);
  }

  stroke(100,255,100);
  fill(50,200,50);
  box(PIXELS_PER_FOOT * 32, 1, PIXELS_PER_FOOT * 32);
  
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
  
}

void mouseMoved() {
  //cam.pan(radians(mouseX - pmouseX) / 10.0);
  //cam.tilt(radians(mouseY - pmouseY) / 10.0);
}
