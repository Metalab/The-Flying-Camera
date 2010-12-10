#
#  Scene.rb
#  CtF
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

class Scene
  def redraw(tick)
    r = rand / 10.0
    glClearColor(r,r,r,0)
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glBegin(GL_LINE_STRIP)
      glVertex3f( -0.9,  -0.7, 0.0); 
      glVertex3f( 0.9,  -0.7, 0.0); 
      glVertex3f( 0.9,  0.9, 0.0); 
      glVertex3f( -0.9,  0.9, 0.0); 
      glVertex3f( -0.9,  -0.7, 0.0); 
    glEnd

  end
end
