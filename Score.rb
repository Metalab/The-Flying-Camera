#
#  Score.rb
#  The Flying Camera
#
#  Created by Thomas R. Koll on 12.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

class Score
  attr_accessor :score, :point_size, :x, :y, :z, :binary

  def initialize(x,y,z)
    self.x = x
    self.y = y
    self.z = z
    self.score = 0
    self.point_size = 0.03
    self.binary = false
  end

  def draw
    (self.binary ?
          (self.score/16).to_s(2).split('').reverse :
          self.score.to_s.split('').reverse)
    .each_with_index do |p, i|
      glPushMatrix
      c = self.binary ? (p == "1" ? 0.8 : 0.2) : p.to_f/10.0
      glColor3f(c, c, c)
      glTranslatef(self.x + i * point_size + point_size / 4, self.y, i*0.1)

      glBegin(GL_QUADS)
        glVertex3f( 0.0,   0.0, 0.0); 
        glVertex3f( 0.0,   point_size, 0.0); 
        glVertex3f( - point_size,  point_size, 0.0); 
        glVertex3f( - point_size,  0.0, 0.0); 
        glVertex3f( 0.0,   0.0, 0.0); 
      glEnd

      glPopMatrix
    end
  end
  
  def +(score)
    self.score += score
    self
  end

  def -(score)
    self.score -= score
    self
  end
end
