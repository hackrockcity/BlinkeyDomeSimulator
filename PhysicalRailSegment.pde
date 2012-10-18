class VirtualRailSegment {
  String m_name;
  int m_len;
  PVector m_start;
  PVector m_end;
  
  VirtualRailSegment(String name, PVector start, PVector end, int len) {
    m_name = name;
    m_len = len;
    m_start = start;
    m_end = end;
  }
  
  void draw(color c) {
    stroke(c);
    
    for (int i; i < m_len; i++) {
      
      amt = (1.0 / len) * i;
      
      int x = lerp(m_start.x, m_end.x, amt);
      int y = lerp(m_start.y, m_end.y, amt);
      
      rect(x, y, 5, 5);
    }
    
  }
}
