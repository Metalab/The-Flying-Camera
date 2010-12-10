#
#  Movable.rb
#  CtF
#
#  Created by Thomas R. Koll on 10.12.10.
#  Copyright (c) 2010 ananasblau. All rights reserved.
#

module Movable
  attr_accessor :speed, :turns, :last_turn, :orientation
  MIN_SPEED = 2
  MAX_SPEED = 10
  MAX_TURN = 5
  SPEED_FACTOR = 0.001

  def turns_sum
    self.turns = self.turns[0..(MAX_TURN*3)]
    return (self.turns||[]).inject {|sum, i| sum + i}
  end

  def turn(val)
    self.turns.unshift(val)
    self.last_turn = self.turns_sum.abs > 1 ? val : 0
    self.orientation = (self.orientation + self.turns_sum) % 360
  end
  
  def speedUp(val)
    self.speed = [[self.speed + val, MAX_SPEED].min, MIN_SPEED].max
  end
  
  def radians
    (self.orientation * Math::PI / 180) || 0
  end

  def camera_orientation
    (orientation - 90) % 360
  end

  def move(turn = nil)
    # First of all rotate
    glRotatef(self.orientation, 0, 0, 1)

    # Move x and y coords
    self.turn(turn || self.last_turn || 0)
    self.turns.shift if turn.nil?
    self.turns.unshift(0)
    self.x += Math.cos(self.radians) * self.speed * SPEED_FACTOR
    self.y += Math.sin(self.radians) * self.speed * SPEED_FACTOR
  end
end
