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
    self.score = 0
    self.score_history = {}

    self.view_width = 55
    self.view_angle = [270 - view_width / 2, 270 + view_width / 2]
  end

  def redraw(tick)
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
      c_x = Math.cos(radians(view_angle[0])) / 5.0
      c_y = Math.cos(radians(view_angle[1])) / 5.0
      glVertex2f(c_x, c_y)
      glColor3f(1,1,1)
      glVertex2f(-0.03, 0)
      glColor3f(0,0,0)
      glVertex2f(-c_x, c_y)
    glEnd
    glPopMatrix
    glFlush
  end

  def turn_with_camera(direction)
    orientation_before = self.orientation
    self.turn_without_camera(direction)
    self.view_angle[0] += orientation_before - self.orientation
    self.view_angle[1] += orientation_before - self.orientation
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
    end
  end

  # count planes in view
  def make_picture(planes)
    score_history.map{|k, history| score_history[k] = history[0..10] }

    # TODO set planes that are not in view to []
    objects_in_view(planes).each do |hit|
      score_history[hit.object_id] ||= []
      score_history[hit.object_id].unshift(1)
      self.score += score_history[hit.object_id].inject {|sum, i| sum + i}
    end
    score_history.map{|k, history| history.unshift(0); }
  end
  
  
end
