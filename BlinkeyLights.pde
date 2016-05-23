
class BlinkeyLights {
  ArrayList<BlinkeyLight> blinkeyLights;

  BlinkeyLights( int radius_, int strips_, int lights_per_strip_) {
    blinkeyLights = new ArrayList<BlinkeyLight>();

    radius_ = radius_ * 10;

    for (int light = lights_per_strip_ -1; light > 0; light--) {
      for (int strip = 0; strip < strips_; strip++) {  

        //float inclination = HALF_PI + (HALF_PI)*((float)light/lights_per_strip_);
        float inclination = HALF_PI + (HALF_PI*0.9)*((float)light/lights_per_strip_);
        float azimuth     = (2*PI)*((float)strip/strips_);

        float x = radius_ * cos(azimuth) * sin(inclination);
        float z = radius_ * sin(azimuth) * sin(inclination);
        float y = radius_ *                cos(inclination);

        blinkeyLights.add(new BlinkeyLight(x, y, z));
      }
    }
  }

  int size() {
    return blinkeyLights.size();
  }

  void update(color[] imageData) {
    for (int i = 0; i < blinkeyLights.size(); i++) {
      blinkeyLights.get(i).setColor(imageData[i]);
    }
  }

  void draw() {
    for (int i = 0; i < blinkeyLights.size(); i++) { 
      (blinkeyLights.get(i)).draw();
    }
  }
}