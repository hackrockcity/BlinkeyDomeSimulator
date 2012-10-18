class VirtualRailSegment {
  String m_name;
  int m_strip;
  int m_offset;
  int m_length;
  
  VirtualRailSegment(String name, int strip, int offset, int length) {
    m_name = name;
    m_strip = strip;
    m_offset = offset;
    m_length = length;
  }
  
  void draw(color c) {
    stroke(c);
    line(m_strip, m_offset, m_strip, m_offset + m_length);
  }
}
