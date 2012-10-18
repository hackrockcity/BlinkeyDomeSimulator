class RailSegmentPattern extends Pattern {
  RailSegment m_segment;
  
  
  RailSegmentPattern(RailSegment segment, int channel, int pitch, int velocity) {
    super(channel, pitch, velocity);
    m_segment = segment;
  }
  
  
  void draw() {
    // Display one flash of color, then end.
    m_segment.draw(color(0,0,255));
    
    m_isDone = true;
  }
}

