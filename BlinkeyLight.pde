import processing.opengl.*;

class BlinkeyLight {
  float rad = .5;
  float x = 0;
  float y = 0;
  float z = 0;
  color c = color(1,1,1);
  
  BlinkeyLight(float x_, float y_, float z_) {
    x = x_;
    y = y_;
    z = z_;
  }
  
  void setColor(color c_) {
    c = c_;
  }
  
  void draw() {
    pushMatrix();
      translate(x, y, z);
      stroke(c);
      fill(c);
      scale(rad);
      // Sphere is too slow, useless.
      box(1);
      //sphere(1);
    popMatrix();
  }
}
