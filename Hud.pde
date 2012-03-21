class Hud {
  
  int boxHeight = 155;
  
  void draw() {
    pCamera.beginHUD();
      noLights();
      strokeWeight(0);
      fill(255,255,255,200);
      rect(10,10,width-20,30);
      textFont(font); 
      fill(0,0,0);
      textAlign(CENTER);
      text("Dome Shit", width/2-20, 32);
      fill(255,255,255,100);
      rectMode(CORNER);
      rect(10, height-boxHeight-10, 45,boxHeight);
    pCamera.endHUD();
  }
  
}
