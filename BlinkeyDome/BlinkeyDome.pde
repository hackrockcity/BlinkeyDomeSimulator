import processing.opengl.*;

int PIXELS_PER_FOOT = 24;

void setup() {
  size(1024,1024,OPENGL);
  
}

void draw() {
  background(0);
  
  camera(
    width/2,                  // eye x
    height/2+PIXELS_PER_FOOT*6,  // eye y
    0,                  // eye z 
    mouseX,             // center x
    mouseY,             // center y
    PIXELS_PER_FOOT * 8, // center z
    0,
    -1,
    0
   );

  stroke(255,100,100);
  fill(200,50,50);
  lights();
  translate(width/2, height/2, 0);
  sphere(PIXELS_PER_FOOT * 16);  
  stroke(100,255,100);
  fill(50,200,50);
  box(PIXELS_PER_FOOT * 32, 1, PIXELS_PER_FOOT * 32);


}
