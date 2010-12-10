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
  attr_accessor :camera, :camera_angle,
    :score, :score_history

  def initialize
    self.orientation = 0
    self.speed = 2
    self.turns = []
    self.position (0,0,0)
    self.score = 0
    self.score_history = {}

    # 90 oeffnungswinkel der kamera
    # 315 orientation erste grenze
    # 225 orientation zweite grenze
    self.camera_angle = [40, [290, 250]]
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
    self.camera_angle[1][0] = (self.camera_orientation + self.camera_angle[0] / 2) % 360
    self.camera_angle[1][1] = (self.camera_orientation - self.camera_angle[0] / 2) % 360

    c = self.camera ? 1 : -1
    glPushMatrix

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

  # count planes in view
  def make_picture(planes)
    score_history.map{|k, history| score_history[k] = history[0..10] }

    # TODO only planes in view
    check(planes).each do |hit|
      score_history[hit.object_id] ||= []
      score_history[hit.object_id].unshift(1)
      self.score += score_history[hit.object_id].inject {|sum, i| sum + i}
      puts score
    end
    puts ""
    score_history.map{|k, history| history.unshift(0); }
#    puts score_history.inspect
  end

  def check(enemies)
    enemies.collect do |enemy|
      # nur im Rückschritt liegt die Zukunft
      b = self.x + enemy.x
      a = self.y + enemy.y
      gamma = Math.atan2(b,a)
      # FIXME only scoring planes above?
      gamma = ( -1 *((gamma / Math::PI * 180)) + 90) % 360
      n = camera_angle[1][0]
      m = camera_angle[1][1]
      if m < n && gamma > m && gamma < n
        enemy
      elsif m > n && (gamma > m || gamma < n)
        enemy
      else
        nil
      end
    end.compact
  end
end
