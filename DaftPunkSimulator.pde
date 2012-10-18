import hypermedia.net.*;
import java.util.concurrent.*;

int lights_per_strip = 32*5;    // Number of lights along the strip
int strips = 8;
int packet_length = strips*lights_per_strip*3 + 1;

Boolean demoMode = true;
BlockingQueue newImageQueue;

UDP udp;
List<VirtualRailSegment> leftRail;    // Rail segment mapping

int animationStep = 0;
int maxConvertedByte = 0;

void setup() {
  size(1024, 850);
  colorMode(RGB,255);
  frameRate(60);
  newImageQueue = new ArrayBlockingQueue(2);

  udp = new UDP( this, 58082 );
  udp.listen( true );
  
  leftRail = Collections.synchronizedList(new LinkedList<VirtualRailSegment>());
  leftRail.add(new VirtualRailSegment("A2", 0, 29, 24));
  leftRail.add(new VirtualRailSegment("A3", 0, 55, 24));
  leftRail.add(new VirtualRailSegment("A4", 0, 81, 25));
  leftRail.add(new VirtualRailSegment("A5", 0, 107, 25));
  leftRail.add(new VirtualRailSegment("A6", 0, 132, 25));

}


int convertByte(byte b) {
  int c = (b<0) ? 256+b : b;

  if (c > maxConvertedByte) {
    maxConvertedByte = c;
    println("Max Converted Byte is now " + c);
  }  
  
  return c;
}

void receive(byte[] data, String ip, int port) {  
  //println(" new datas!");
  if (demoMode) {
    println("Started receiving data from " + ip + ". Demo mode disabled.");
    demoMode = false;
  }
  
  if (data[0] == 2) {
    // We got a new mode, so copy it out
    String modeName = new String(data);

    return;
  }

  if (data[0] != 1) {
    println("Packet header mismatch. Expected 1, got " + data[0]);
    return;
  }

  if (data.length != packet_length) {
    println("Packet size mismatch. Expected "+packet_length+", got " + data.length);
    return;
  }

  if (newImageQueue.size() > 0) {
    println("Buffer full, dropping frame!");
    return;
  }

  color[] newImage = new color[strips*lights_per_strip];

  for (int i=0; i< strips*lights_per_strip; i++) {
      // Processing doesn't like it when you call the color function while in an event
      // go figure
      newImage[i] = (int)(0xff<<24 | convertByte(data[i*3 + 1])<<16) | (convertByte(data[i*3 + 2])<<8) | (convertByte(data[i*3 + 3]));
  }
  try { 
    newImageQueue.put(newImage);
  } 
  catch( InterruptedException e ) {
    println("Interrupted Exception caught");
  }
}


void draw() {
  background(0);

  if (newImageQueue.size() > 0) {
    color[] newImage = (color[])newImageQueue.remove();
  }
}

