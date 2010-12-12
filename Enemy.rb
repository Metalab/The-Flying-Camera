#
#  Enemy.rb
#  CtF
#
#  Created by Thomas R. Koll on 10.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#
require 'placable'
require 'movable'
class Enemy
  include Placable
  include Movable
  
  attr_accessor :team

  def initialize(team)
    self.team = team
    self.x = rand * 2 - 1
    self.y = rand * 2 - 1
    self.orientation = rand(360)
    self.speed = 2
    self.turns = []

  end

  def redraw(tick)
    self.randomize
    glPushMatrix
    place
    move
    colour
    Plane.draw
    self.draw

    glPopMatrix
  end
  
  def colour
   glColor3f(*self.team.colour)
  end

  # Markings
  def draw
    case self.team.name
    when 'Kaiserliche Fliegertruppe'
      iron_cross(-0.005,  0.05, 0)
      iron_cross(-0.005, -0.05, 0)
    when 'Royal Flying Corps'
      raf(-0.005,  0.05, 0)
      raf(-0.005, -0.05, 0)
    end
  end
  def iron_cross(x,y,z)
    glPushMatrix
    glTranslatef(x, y, z)
    glColor3f(0, 0, 0)
    s = 0.01
    glBegin(GL_QUADS)
      glVertex3f( s,-s/3.5, 0.0); 
      glVertex3f( s, s/3.5, 0.0); 
      glVertex3f(-s, s/3.5, 0.0); 
      glVertex3f(-s,-s/3.5, 0.0); 
      glVertex3f( s,-s/3.5, 0.0); 
    glEnd
    glBegin(GL_QUADS)
      glVertex3f( s/3.5,-s, 0.0); 
      glVertex3f( s/3.5, s, 0.0); 
      glVertex3f(-s/3.5, s, 0.0); 
      glVertex3f(-s/3.5,-s, 0.0); 
      glVertex3f( s/3.5,-s, 0.0); 
    glEnd
    glPopMatrix
  end

  def raf(x, y, z)
    glPushMatrix
    glTranslatef(x, y, z)
    glColor3f(0,	0.13,	0.48)
    circle(0.009)
    glColor3f(1, 1, 1)
    circle(0.006)
    glColor3f(0.8, 0.06, 0.14)
    circle(0.002)
    glPopMatrix
  end

  def circle(radius, segments = 20)
    glBegin(GL_TRIANGLE_FAN)
    glVertex2f(0, 0)
    (segments+1).times do |i|
      # current angle
      theta = 2.0 * Math::PI * i / segments;
      x = radius * Math.cos(theta);
      y = radius * Math.sin(theta);
      glVertex2f(x, y)

    end
    glEnd
  end
  
  def randomize
    self.speedUp(rand * 2 - 1)
    self.turn(rand(self.turns_sum||1) * (rand - 0.5))
  end
end
