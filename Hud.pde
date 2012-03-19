class Hud {

  void draw() {
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
  
}
