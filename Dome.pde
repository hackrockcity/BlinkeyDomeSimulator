import processing.opengl.*;



class Dome {
  float rho;
  float factor;
  
  Dome(float radius_) {
    
    rho = radius_*10;
    factor = TWO_PI / 20.0;
  }
  
  void draw() {
    stroke(255,100,100);
    fill(200,50,50);
  
    for (float phi = 0.0; phi < HALF_PI; phi += factor) {
      beginShape(QUAD_STRIP);
      for (float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
        float x = rho * sin(phi) * cos(theta);
        float z = rho * sin(phi) * sin(theta);
        float y = -rho * cos(phi);

        vertex(x, y, z);

        x = rho * sin(phi + factor) * cos(theta);
        z = rho * sin(phi + factor) * sin(theta);
        y = -rho * cos(phi + factor);

        vertex(x, y, z);
      }
      endShape(CLOSE);
    }
  }
  
}

