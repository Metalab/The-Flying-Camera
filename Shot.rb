#
#  Shot.rb
#  The Flying Camera
#
#  Created by Thomas R. Koll on 12.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

class Shot
  include Movable
  include Placable

  attr_accessor :x, :y, :orientation
  

  def initialize(x,y,orientation)
    self.x = x
    self.y = y
    self.z = 0
    self.speed = 10
    self.orientation = orientation
  end
  
  def redraw
    glPushMatrix
  
    # shot is leaving view field
    out_of_view = self.x > 1 || self.x < -1 || self.y > 1 || self.y < -1

    place
    self.move(0)
    glColor3f(1,1,1)
    glBegin(GL_QUADS)
      glVertex3f( 0.0,   0.0, 0.0); 
      glVertex3f( 0.0,   0.002, 0.0); 
      glVertex3f(-0.002, 0.002, 0.0); 
      glVertex3f(-0.002, 0.0, 0.0); 
      glVertex3f( 0.0,   0.0, 0.0); 
    glEnd
    glPopMatrix
   return nil if out_of_view
   return self
  end
end
