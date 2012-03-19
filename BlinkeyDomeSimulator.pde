import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.opengl.*;

int PIXELS_PER_FOOT = 10;
int DOME_RADIUS = 8;
float rho = DOME_RADIUS*10;
float factor = TWO_PI / 20.0;
float x, y, z;

PeasyCam pCamera;

void setup() {
  size(1024,1024,OPENGL);
  pCamera = new PeasyCam(this, 0,0,10,200);
  pCamera.setMinimumDistance(1);
  pCamera.setMaximumDistance(150*10);
  pCamera.setSuppressRollRotationMode();
  pCamera.rotateX(0.2);
  pCamera.lookAt(0,-10,-20);
  pCamera.setWheelScale(0.05);

}

void draw() {
  background(0);
  stroke(255,100,100);
  fill(200,50,50);
  lights();
  
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
  
}
