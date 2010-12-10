#
#  Plane.rb
#  CtF
#
#  Created by Thomas R. Koll on 10.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

class Plane
  # It's an airplane!
  def self.draw
    # Main wing
    glBegin(GL_QUADS)
      glVertex3f( 0.01,  -0.07, 0.0); 
      glVertex3f( 0.01,   0.07, 0.0); 
      glVertex3f(-0.02,  0.07, 0.0); 
      glVertex3f(-0.02, -0.07, 0.0); 
      glVertex3f( 0.01,  -0.07, 0.0); 
    glEnd
    # Body
    glBegin(GL_QUADS)
      glVertex3f( 0.025, -0.01, 0.0); 
      glVertex3f( 0.025,  0.01, 0.0); 
      glVertex3f(-0.09,   0.01, 0.0); 
      glVertex3f(-0.09,  -0.01, 0.0); 
      glVertex3f( 0.025, -0.01, 0.0); 
    glEnd
    # Tail
    glBegin(GL_QUADS)
      glVertex3f(-0.07, -0.03, 0.0); 
      glVertex3f(-0.07,  0.03, 0.0); 
      glVertex3f(-0.08,  0.03, 0.0); 
      glVertex3f(-0.08, -0.03, 0.0); 
      glVertex3f(-0.07, -0.03, 0.0); 
    glEnd
  end
end
