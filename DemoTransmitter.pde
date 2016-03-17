class DemoTransmitter extends Thread {
  
  int animationStep = 0;
  
  color[] MakeDemoFrame() {
    int image_size = strips*lights_per_strip;
  
    color[] imageData = new color[image_size];
  
    for (int i = 0; i < imageData.length; i++) {
      if (animationStep == i%10) {
        imageData[i] = color(255);
      }
      else {
        imageData[i] = color(0);
      }
    }
    
    animationStep = (animationStep + 1)%10;
  
    return imageData;
  }
  
  DemoTransmitter() {
  }
  
  void run() {
    while(demoMode) {
      try {
        if (newImageQueue.size() < 1) {
          color imageData[] = MakeDemoFrame();
          newImageQueue.put(imageData);
        }
        Thread.sleep(25);
      } 
      catch( InterruptedException e ) {
        println("Interrupted Exception caught");
      }
    }
  }
}