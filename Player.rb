#
#  Player.rb
#  CtF
#
#  Created by Thomas R. Koll on 09.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#
#require 'placable'
#require 'movable'
require 'visibility'

class Player
  include Placable
  include Movable
  include Visibility

  attr_accessor :view_angle,
    :score, :score_history

  def initialize
    self.orientation = 0
    self.speed = 2
    self.turns = []
    self.position (0,0,0)
    self.score_history = {}
    self.score = Score.new(-0.95, -0.95, 0)

    self.view_width = 70
    self.view_angle = [self.orientation + 90 + view_width / 2, self.orientation + 90 - view_width / 2]
  end

  def redraw(tick)
    self.score.draw
    glPushMatrix
      glColor3f(0.7,0.7,0.7)
      place
      move
      Plane.draw
      draw_camera
    glPopMatrix
  end

  def draw_camera
    glPushMatrix

    glBegin(GL_LINE_STRIP)
      glColor3f(0,0,0)
      c_x = Math.cos(radians(self.orientation - view_angle[0] + 180)) / 3.0
      c_y = Math.sin(radians(self.orientation - view_angle[0] + 180)) / 3.0
      glVertex2f(c_x, c_y)
      glColor3f(1,1,1)
      glVertex2f(-0.03, 0)
      glColor3f(0,0,0)
      c_x = Math.cos(radians(self.orientation - view_angle[1] + 180)) / 3.0
      c_y = Math.sin(radians(self.orientation - view_angle[1] + 180)) / 3.0
      glVertex2f(c_x, c_y)
    glEnd
    glPopMatrix
    glFlush
  end

  def turn_with_camera(direction)
    difference = self.turn_without_camera(direction)
    self.view_angle[0] = (self.view_angle[0] + difference) % 360
    self.view_angle[1] = (self.view_angle[1] + difference) % 360
  end
  alias_method :turn_without_camera, :turn
  alias_method :turn, :turn_with_camera

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
        self.view_angle.collect!{|a| a + 180 % 380 }
      when 115 # score
        self.score.binary = !self.score.binary
    end
  end

  # count planes in view
  def make_picture(planes)
    score_delta = 1
    score_history.map{|k, history| score_history[k] = history[0..40] }
    # TODO set planes that are not in view to []
    planes_scored = objects_in_view(planes).each do |hit|
      score_history[hit.object_id] ||= []
      score_history[hit.object_id].unshift(1)
      score_delta += score_history[hit.object_id].inject {|sum, i| sum + i}
    end
    score_delta *= planes_scored.size
    self.score + score_delta
    score_history.map{|k, history| history.unshift(0); }
  end
  
end
