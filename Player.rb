#
#  Player.rb
#  CtF
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#
#require 'placable'
#require 'movable'

class Player
  include Placable
  include Movable
  attr_accessor :camera

  def initialize
    self.orientation = 0
    self.speed = 2
    self.turns = []
    self.position (0,0,0)
  end

  def redraw(tick)
    glPushMatrix
      place
      glColor3f(0.7,0.7,0.7)
      move
      Plane.draw
      draw_camera

    glPopMatrix
  end
  
  def draw_camera
    c = self.camera ? 1 : -1
    glPushMatrix
    puts c
    glBegin(GL_LINE_STRIP)
      glColor3f(0,0,0)
      glVertex2f(0.17, c*0.5)
      glColor3f(1,1,1)
      glVertex2f(-0.03, 0)
      glColor3f(0,0,0)
      glVertex2f(-0.20, c*0.5)
    glEnd
    glPopMatrix
    glFlush
  end

  def keyDown(key)
    case key
      when 128 # up
        speedUp(1)
      when 129 # down
        speedUp(-1)
      when 130 # left
        turn(1)
      when 131 # right
        turn(-1)
      when 99 # c
        self.camera = !self.camera
    end
  end
end
