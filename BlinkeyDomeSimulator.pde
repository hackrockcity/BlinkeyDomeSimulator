import damkjer.ocd.*;
import processing.opengl.*;

int PIXELS_PER_FOOT = 10;
int DOME_RADIUS = 8;
Camera cam;

void setup() {
  size(1024,1024,OPENGL);
  cam = new Camera(this,500);

}

void draw() {
  background(0);
  
  cam.feed();
  stroke(255,100,100);
  fill(200,50,50);
  lights();
  //translate(width/2, height/2, 0);
  
  // Sphere is messed up. This is a workaround See:
  // http://forum.processing.org/topic/3d-sphere-issue
  pushMatrix();
  scale(PIXELS_PER_FOOT * 16);
  sphere(1);  
  popMatrix();

  stroke(100,255,100);
  fill(50,200,50);
  box(PIXELS_PER_FOOT * 32, 1, PIXELS_PER_FOOT * 32);
  
  if (keyPressed) {
    if (key == 'w') {
      cam.dolly(-5);
    }
    else if (key == 's') {
      cam.dolly(5);
    }
    else if (key == 'a') {
      cam.truck(-5);
    }
    else if (key == 'd') {
      cam.truck(5);
    }
  }
  
}

void mouseMoved() {
  cam.pan(radians(mouseX - pmouseX) / 10.0);
  cam.tilt(radians(mouseY - pmouseY) / 10.0);
}
