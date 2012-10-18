class ImageHud {
  PImage img;
  float x;
  float y;
  
  ImageHud(float x_, float y_, int w_, int h_) {
    x = x_;
    y = y_;
    img = new PImage(w_,h_);
  }
  
  void update(color[] imageData) {
    img.loadPixels();
    for (int i = 0; i < blinkeyLights.size(); i++) {
      img.pixels[i] = imageData[i];
    }
    img.updatePixels();
  }
  
  void draw() {
    pCamera.beginHUD();
      image(img, x, y);
    pCamera.endHUD();
    
//    pushMatrix();
//    translate(0, 0.5, 0);
//  
//    beginShape();
//    texture(groundTexture);
//    textureMode(NORMALIZED);
//  
//    vertex(w_, h_, 0, 0, 0);
//    vertex(bound, .5, -bound, 1, 0);
//    vertex(bound, .5, bound, 1, 1);
//    vertex(-bound, .5, bound, 0, 1);
//    endShape();
//    popMatrix();
  }
}
